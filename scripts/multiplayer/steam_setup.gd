extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_steam()

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam Initialize?: %s " % initialize_response)

func _init() -> void:
	# Sets App ID
	OS.set_environment("SteamAppId", str(480))
	OS.set_environment("SteamGameId", str(480))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Steam.run_callbacks() #Enables Callbacks
