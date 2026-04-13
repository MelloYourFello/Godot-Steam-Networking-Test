extends SpringArm3D

@export var stick_sensitivity: float = 150.0
@export var mouse_sensitivity: float = .07
var mouse_input: Vector2 = Vector2()
var camera_rig_height: float = position.y

@onready var camera: Camera3D = $Camera3D
@onready var player: Node3D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spring_length = camera.position.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var look_input := Input.get_vector("view_right", "view_left", "view_down", "view_up")
	look_input = stick_sensitivity * look_input * delta
	look_input += mouse_input
	mouse_input = Vector2()
	
	rotation_degrees.x += look_input.y
	rotation_degrees.y += look_input.x
	rotation_degrees.x = clampf(rotation_degrees.x, -60, 70)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = -event.relative * mouse_sensitivity
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta: float) -> void:
	position = player.position + Vector3(0,camera_rig_height,0)
