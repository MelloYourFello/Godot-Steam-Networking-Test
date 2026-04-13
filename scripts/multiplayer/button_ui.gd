extends Control

@onready var host_button: Button = $VBoxContainer/HostButton
@onready var join_button: Button = $VBoxContainer/JoinButton
@onready var lobby_id_prompt: LineEdit = $VBoxContainer/LobbyIDPrompt


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_host_button_pressed() -> void:
	ServerSetup.host_lobby()

func _on_lobby_id_prompt_text_changed(new_text: String) -> void:
	join_button.disabled = (new_text.length() == 0)

func _on_join_button_pressed() -> void:
	ServerSetup.join_lobby(lobby_id_prompt.text.to_int())
