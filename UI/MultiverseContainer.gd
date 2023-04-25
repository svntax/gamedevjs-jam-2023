extends Panel

onready var message_label = $MessageLabel
onready var root = $Root
onready var supporters_square = get_node("%SupportersCountSquare")
onready var supporters_triangle = get_node("%SupportersCountTriangle")
onready var supporters_circle = get_node("%SupportersCountCircle")

func _ready():
	root.hide()
	message_label.show()
	# Fetch the supporters for each faction. TODO
	#var result = Near.call_view_method(Globals.CONTRACT_NAME, "get_supporters")
	var result = {}
	if result is GDScriptFunctionState:
		result = yield(result, "completed")
	if result.has("error"):
		message_label.set_text("Error: Failed to fetch data.")
	else:
		message_label.hide()
		root.show()
		
		# TODO fetch data
		supporters_square.set_text("1234")
		supporters_triangle.set_text("5678")
		supporters_circle.set_text("9012")
