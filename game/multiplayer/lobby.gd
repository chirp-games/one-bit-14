extends Node

const SERVER_IP = "127.0.0.1:7000"
const SERVER_PORT = 7000

func host_game() -> Error:
	var server = ENetMultiplayerPeer.new()
	var err = server.create_server(SERVER_PORT, 1)
	if err:
		return err
	multiplayer.multiplayer_peer = server
	return Error.OK

func join_game() -> Error:
	var client = ENetMultiplayerPeer.new()
	var err = client.create_client(SERVER_IP, SERVER_PORT)
	if err:
		return err
	multiplayer.multiplayer_peer = client
	return Error.OK

func quit_game() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

@rpc("authority", "call_local")
func start_game(level: MultiplayerLevelInfo) -> void:
	LevelManager.level = level
	get_tree().change_scene_to_file("res://game/multiplayer/render.tscn")
