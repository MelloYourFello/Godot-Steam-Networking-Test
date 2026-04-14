extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.network_messages_session_request.connect(_on_network_messages_session_request)
	Steam.network_messages_session_failed.connect(_on_network_messages_session_failed)
	
	# Check for command line arguments
	check_command_line()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If the player is connected, read packets
	if lobby_id > 0:
		read_messages()
