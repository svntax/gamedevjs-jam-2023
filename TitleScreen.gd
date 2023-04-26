extends Node2D

var config = {
	"network_id": "testnet",
	"node_url": "https://rpc.testnet.near.org",
	"wallet_url": "https://wallet.testnet.near.org",
	#"wallet_url": "https://testnet.mynearwallet.com",
}

func _ready():
	# Default size 1280x720
	OS.window_size = Vector2(1280, 720)
	# Center the window after resizing
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	# NEAR setup
	if Near.near_connection == null:
		Near.start_connection(config)
	Globals.current_support_count = 0

func _on_PlayButton_pressed():
	get_tree().change_scene("res://UI/Screens/MainMenuScreen.tscn")
