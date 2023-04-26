extends Panel

onready var message_label = $MessageLabel
onready var root = $Root
onready var supporters_square = get_node("%SupportersCountSquare")
onready var supporters_triangle = get_node("%SupportersCountTriangle")
onready var supporters_circle = get_node("%SupportersCountCircle")

onready var user_support_square = $"%UserCountSquare"
onready var user_support_triangle = $"%UserCountTriangle"
onready var user_support_circle = $"%UserCountCircle"

onready var refresh_button = $"%RefreshButton"

func _ready():
	root.hide()
	message_label.show()
	refresh_button.disabled = true
	var success = fetch_data()
	if success is GDScriptFunctionState:
		success = yield(success, "completed")
	
	var user_success = fetch_user_data()
	if user_success is GDScriptFunctionState:
		user_success = yield(user_success, "completed")
	
	refresh_button.disabled = false

# Returns if data was successfully fetched.
func fetch_data() -> bool:
	# Fetch the supporters for each faction.
	var result = Near.call_view_method(Globals.CONTRACT_NAME, "get_supporters_data")
	if result is GDScriptFunctionState:
		result = yield(result, "completed")
	if result.has("error"):
		message_label.set_text("Error: Failed to fetch data.")
		return false
	else:
		message_label.hide()
		root.show()
		
		var data = parse_json(result.data)
		if typeof(data) == TYPE_ARRAY and data.size() == 3:
			Globals.supporters_square = data[0]
			Globals.supporters_circle = data[1]
			Globals.supporters_triangle = data[2]
			update_supporters_data()
			return true
		else:
			supporters_square.set_text("Error")
			supporters_circle.set_text("Error")
			supporters_triangle.set_text("Error")
			return false

func fetch_user_data() -> bool:
	if Globals.wallet_connection != null and Globals.wallet_connection.is_signed_in():
		# Fetch data for specific user
		var user_data = Near.call_view_method(Globals.CONTRACT_NAME, "get_user_support_data", \
				{"account": Globals.wallet_connection.get_account_id()})
		if user_data is GDScriptFunctionState:
			user_data = yield(user_data, "completed")
		if user_data.has("error"):
			print("Failed to get user data")
			user_support_square.set_text("Error")
			user_support_circle.set_text("Error")
			user_support_triangle.set_text("Error")
			return false
		else:
			var data = parse_json(user_data.data)
			if typeof(data) == TYPE_DICTIONARY:
				if data.has("support_square"):
					user_support_square.set_text(str(data.support_square))
				else:
					user_support_square.set_text("Error")
				if data.has("support_circle"):
					user_support_circle.set_text(str(data.support_circle))
				else:
					user_support_circle.set_text("Error")
				if data.has("support_triangle"):
					user_support_triangle.set_text(str(data.support_triangle))
				else:
					user_support_triangle.set_text("Error")
				return true
			else:
				return false
	else:
		print("User not signed in")
		user_support_square.set_text("N/A")
		user_support_circle.set_text("N/A")
		user_support_triangle.set_text("N/A")
		return false

func update_supporters_data() -> void:
	supporters_square.set_text(str(int(Globals.supporters_square)))
	supporters_triangle.set_text(str(int(Globals.supporters_triangle)))
	supporters_circle.set_text(str(int(Globals.supporters_circle)))

func _on_RefreshButton_pressed():
	refresh_button.disabled = true
	
	var success = fetch_data()
	if success is GDScriptFunctionState:
		success = yield(success, "completed")
	
	var user_success = fetch_user_data()
	if user_success is GDScriptFunctionState:
		user_success = yield(user_success, "completed")
		
	refresh_button.disabled = false
