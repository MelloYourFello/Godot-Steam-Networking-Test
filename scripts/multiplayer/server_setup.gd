extends Control

var lobby_id: int = 0
var peer: SteamMultiplayerPeer
var lobby_members: Array = []
var lobby_members_max: int = 10
var is_host: bool = false
var is_joining: bool = false

@export var player_scene: PackedScene

@onready var host_button: Button = $VBoxContainer/HostButton
@onready var join_button: Button = $VBoxContainer/JoinButton
@onready var lobby_id_prompt: LineEdit = $VBoxContainer/LobbyIDPrompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(on_lobby_created)
	Steam.lobby_joined.connect(on_lobby_joined)

func host_lobby():
	Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_PUBLIC, lobby_members_max)
	
	is_host = true

func on_lobby_created(result: int, created_lobby_id: int):
	if result == Steam.Result.RESULT_OK:
		
		lobby_id = created_lobby_id
		
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_host()
		
		
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(remove_player)
		add_player()
		
		print("Lobby Created, Lobby ID: ", lobby_id)

func join_lobby(lobby_id_to_join: int):
	is_joining = true
	Steam.joinLobby(lobby_id_to_join)

func on_lobby_joined(joined_lobby_id: int, permissions: int, locked: bool, response: int):
	
	if !is_joining:
		return
	
	lobby_id = joined_lobby_id
	peer = SteamMultiplayerPeer.new()
	peer.server_relay = true
	peer.create_client(Steam.getLobbyOwner(lobby_id))
	multiplayer.multiplayer_peer = peer
	
	is_joining = false

func add_player(id: int = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func remove_player(id: int):
	if !has_node(str(id)):
		return
	
	get_node(str(id)).queue_free()

func _on_host_button_pressed() -> void:
	host_lobby()
	visible = false

func _on_lobby_id_prompt_text_changed(new_text: String) -> void:
	join_button.disabled = (new_text.length() == 0)

func _on_join_button_pressed() -> void:
	join_lobby(lobby_id_prompt.text.to_int())
	visible = false
