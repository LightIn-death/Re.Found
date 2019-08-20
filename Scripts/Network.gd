extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 4242
const MAX_PLAYER = 5

var players = {}
var self_data = {name = '', position = Vector2(45 , 180) }
var peer = NetworkedMultiplayerENet.new()

func _ready():
	get_tree().connect('network_peer_disconnected', self,'_player_disconnect')
	
	
func create_server():
	players[1] = self_data
	peer.create_server(DEFAULT_PORT, MAX_PLAYER)
	get_tree().set_network_peer(peer)
	
func connect_to_server():
	get_tree().connect("connected_to_server", self,"_connected_to_server")
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	
func _connected_to_server():
	players[get_tree().get_network_unique_id()] = self_data
	rpc('_send_player_info', get_tree().get_network_unique_id(), self_data)
	
	
remote func _send_player_info(id, data):
		if get_tree().is_network_server():
			for peer_id in players:
				rpc_id(id, '_send_player_info', peer_id, players[peer_id])
		players[id] = data
		
		var new_player = load('res://Classes/player.tscn').instance()
		new_player.name = str(id)
		new_player.set_network_master(id)
		get_tree().get_root().add_child(new_player)
		new_player.init()
		
		
		

		

