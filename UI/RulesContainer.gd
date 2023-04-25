extends Panel

onready var page_01 = $ControlsRoot/Page01
onready var page_02 = $ControlsRoot/Page02
onready var pages = [page_01, page_02]
onready var current_page = 0
onready var page_label = $ControlsRoot/PageNumber

func _ready():
	current_page = 0
	update_current_page()

func _on_NextButton_pressed():
	if current_page < pages.size() - 1:
		current_page += 1
		update_current_page()

func _on_BackButton_pressed():
	if current_page > 0:
		current_page -= 1
		update_current_page()

func update_current_page() -> void:
	for i in range(pages.size()):
		if i == current_page:
			pages[i].show()
		else:
			pages[i].hide()
	page_label.set_text(str(current_page+1) + "/" + str(pages.size()))
