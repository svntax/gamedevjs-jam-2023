extends Node2D

onready var new_game_button = $"%NewGameButton"
onready var controls_button = $"%ControlsButton"
onready var multiverse_button = $"%MultiverseButton"
onready var login_button = $"%LoginButton"

onready var rules_container = $UI/RulesContainer
onready var multiverse_container = $UI/MultiverseContainer
onready var newgame_container = $UI/NewGameContainer

var config = {
	"network_id": "testnet",
	"node_url": "https://rpc.testnet.near.org",
	"wallet_url": "https://wallet.testnet.near.org",
	#"wallet_url": "https://testnet.mynearwallet.com",
}
var wallet_connection

onready var login_label = $"%LoginLabel"

func _ready():
	rules_container.hide()
	multiverse_container.hide()
	newgame_container.hide()
	
	# NEAR setup
	if Near.near_connection == null:
		Near.start_connection(config)
	
	wallet_connection = WalletConnection.new(Near.near_connection)
	wallet_connection.connect("user_signed_in", self, "_on_user_signed_in")
	wallet_connection.connect("user_signed_out", self, "_on_user_signed_out")
	if wallet_connection.is_signed_in():
		_on_user_signed_in(wallet_connection)

func _on_user_signed_in(_wallet: WalletConnection):
	login_button.set_text("Logout")
	login_label.set_text("Logged in as:\n" + wallet_connection.account_id)

func _on_user_signed_out(_wallet: WalletConnection):
	login_button.set_text("Login")
	login_label.set_text("Not logged in.\nLog in to be able to leave messages and contribute to a faction's support.")

func _on_NewGameButton_pressed():
	multiverse_container.hide()
	rules_container.hide()
	newgame_container.visible = !newgame_container.visible

func _on_ControlsButton_pressed():
	multiverse_container.hide()
	newgame_container.hide()
	rules_container.visible = !rules_container.visible

func _on_MultiverseButton_pressed():
	rules_container.hide()
	newgame_container.hide()
	multiverse_container.visible = !multiverse_container.visible

func _on_LoginButton_pressed():
	if wallet_connection.is_signed_in():
		wallet_connection.sign_out()
	else:
		wallet_connection.sign_in(Globals.CONTRACT_NAME)

func _on_StartButton_pressed():
	# TODO: introduce story
	get_tree().change_scene("res://SpaceFields/FieldNormal.tscn")
