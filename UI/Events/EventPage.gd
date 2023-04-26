extends MarginContainer

onready var content = $Content

func clear_content() -> void:
	for each in content.get_children():
		each.queue_free()

func add_label(text: String) -> void:
	var label = Label.new()
	content.add_child(label)
	label.autowrap = true
	label.set_text(text)

func add_choice(text: String) -> Button:
	var button = Button.new()
	content.add_child(button)
	button.set_text(text)
	return button
