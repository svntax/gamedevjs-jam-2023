extends Panel

var EventPage = preload("res://UI/Events/EventPage.tscn")

onready var pages = $ControlsRoot/Pages
onready var current_page = 0
onready var page_label = $ControlsRoot/PageNumber
onready var page_header = $ControlsRoot/Header

func _ready():
	current_page = 0
	update_current_page()

func _on_NextButton_pressed():
	if current_page < pages.get_child_count() - 1:
		current_page += 1
		update_current_page()

func _on_BackButton_pressed():
	if current_page > 0:
		current_page -= 1
		update_current_page()

func update_current_page() -> void:
	var page_count = pages.get_child_count()
	for i in page_count:
		if i == current_page:
			pages.get_child(i).show()
		else:
			pages.get_child(i).hide()
	page_label.set_text(str(current_page+1) + "/" + str(page_count))

func clear_pages() -> void:
	for page in pages.get_children():
		page.queue_free()
	current_page = 0

func add_page(header: String, labels: Array, choices: Array) -> Array:
	page_header.set_text(header)
	var page = EventPage.instance()
	pages.add_child(page)
	page.clear_content()
	for message in labels:
		page.add_label(message)
	var buttons = []
	for choice in choices:
		var btn = page.add_choice(choice)
		buttons.append(btn)
	
	update_current_page()
	return buttons
