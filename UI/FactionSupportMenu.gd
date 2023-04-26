extends Panel

signal support_sent()

onready var square_button = $"%SquareButton"
onready var triangle_button = $"%TriangleButton"
onready var circle_button = $"%CircleButton"

onready var confirm_menu = $Root/ConfirmMenu
onready var faction_choice: int = -1
onready var faction_picked_label = $"%FactionPicked"

onready var support_count_label = $"%SupportCountLabel"

onready var response_label = $"%ResponseLabel"
onready var ok_button = $"%OkButton"
onready var confirm_menu_root = $"%ConfirmMenuRoot"

func _ready():
	confirm_menu.hide()
	confirm_menu_root.hide()
	response_label.hide()
	ok_button.hide()
	support_count_label.set_text(str(Globals.current_support_count))

func _on_SquareButton_pressed():
	faction_choice = Globals.Faction.SQUARE
	faction_picked_label.set_text("Square Empire")
	prompt_confirm()

func _on_CircleButton_pressed():
	faction_choice = Globals.Faction.CIRCLE
	faction_picked_label.set_text("Circle Alliance")
	prompt_confirm()

func _on_TriangleButton_pressed():
	faction_choice = Globals.Faction.TRIANGLE
	faction_picked_label.set_text("Triangle Rebellion")
	prompt_confirm()

func prompt_confirm() -> void:
	confirm_menu.show()
	confirm_menu_root.show()
	square_button.disabled = true
	triangle_button.disabled = true
	circle_button.disabled = true

func _on_ConfirmButton_pressed():
	send_support_method_call()

func send_support_method_call():
	response_label.show()
	confirm_menu_root.hide()
	
	var faction_id: int = 0
	if faction_choice == Globals.Faction.SQUARE:
		faction_id = 1
	elif faction_choice == Globals.Faction.CIRCLE:
		faction_id = 2
	elif faction_choice == Globals.Faction.TRIANGLE:
		faction_id = 3
	else:
		return
	
	if Globals.wallet_connection == null:
		response_label.set_text("No wallet connection found!")
		return
	
	var result = Globals.wallet_connection.call_change_method(Globals.CONTRACT_NAME, \
		"add_support", {"support": int(Globals.current_support_count), "faction": faction_id})
	
	if result is GDScriptFunctionState:
		result = yield(result, "completed")
	
	if result.has("error"):
		response_label.set_text("Error:\n" + JSON.print(result.error))
		ok_button.show()
	else:
		response_label.set_text("Support sent!")
		emit_signal("support_sent")
		ok_button.show()

func _on_CancelButton_pressed():
	square_button.disabled = false
	triangle_button.disabled = false
	circle_button.disabled = false
	confirm_menu.hide()
	confirm_menu_root.hide()

func _on_OkButton_pressed():
	queue_free()
