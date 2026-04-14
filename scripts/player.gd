extends CharacterBody3D

@export var speed = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera: Camera3D = $CameraRig/Camera3D
@onready var name_plate: Label3D = $NamePlate
@onready var anim_player: AnimationPlayer = $hero_male/AnimationPlayer

func _ready() -> void:
	name_plate.text = Steam.getPersonaName()

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	
	if !is_multiplayer_authority():
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	turn_to(direction)
	
	var current_speed := velocity.length()
	const  RUN_SPEED := 3.5
	const BLEND_SPEED := 0.2
	
	if current_speed > RUN_SPEED:
		anim_player.play("freehand_run", BLEND_SPEED)
	elif current_speed > 0.0:
		anim_player.play("freehand_walk", BLEND_SPEED, lerp(0.5, 1.75, current_speed/RUN_SPEED))
	else:
		anim_player.play("freehand_idle")

func turn_to(direction: Vector3) -> void:
	if direction.length() > 0:
		var yaw := atan2(-direction.x, -direction.z)
		yaw = lerp_angle(rotation.y, yaw, .25)
		rotation.y = yaw
