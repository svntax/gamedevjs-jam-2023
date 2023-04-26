extends Node2D

var EventMenu = preload("res://UI/Events/EventMenu.tscn")
onready var event_root = $UI/EventRoot
onready var event_timer = $EventTimer

var Star = preload("res://SpaceFields/Star.tscn")
onready var stars_root = $Stars

onready var player_ship = $PlayerShip

onready var faction_support_menu = $UI/FactionSupportMenu

onready var event_count = 0

func _ready():
	faction_support_menu.hide()
	faction_support_menu.connect("support_sent", self, "_on_support_sent")
	for i in range(800):
		var x = rand_range(0, 640)
		var y = rand_range(0, 360)
		var star = Star.instance()
		stars_root.add_child(star)
		star.global_position = Vector2(x, y)
	
	setup_story()

func _on_support_sent():
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene("res://TitleScreen.tscn")

func setup_story():
	stop_travel()
	var start_event = EventMenu.instance()
	event_root.add_child(start_event)
	# Story default
	var buttons = start_event.add_page("STORY", [
		"Travel through this universe in search of the wormhole, but watch out for the various encounters you'll have along the way!"
	],
	[
		"Ok"
	])
	buttons[0].connect("pressed", self, "_start_game")

func _start_game() -> void:
	remove_current_event()
	start_travel()

func remove_current_event() -> void:
	for ev in event_root.get_children():
		ev.queue_free()

func start_travel() -> void:
	player_ship.set_active(true)
	for star in stars_root.get_children():
		star.set_moving(true)
	event_timer.start(rand_range(4, 6))

func stop_travel() -> void:
	player_ship.set_active(false)
	for star in stars_root.get_children():
		star.set_moving(false)

func _on_EventTimer_timeout():
	start_random_event()

func _close_event() -> void:
	remove_current_event()
	
	if event_count >= 5:
		faction_support_menu.show()
		faction_support_menu.update_support_count()
	else:
		start_travel()

func _close_event_good() -> void:
	remove_current_event()
	Globals.current_support_count += 1
	if event_count >= 5:
		faction_support_menu.show()
		faction_support_menu.update_support_count()
	else:
		start_travel()

func start_random_event() -> void:
	stop_travel()
	event_count += 1
	
	var event = EventMenu.instance()
	event_root.add_child(event)
	event.clear_pages()
	var event_choice = Globals.get_random_event()
	var labels = event_choice.labels
	var choices = event_choice.buttons
	var buttons = event.add_page("EVENT", labels, choices)
	event.current_page = 0
	yield(get_tree(), "idle_frame")
	event.update_current_page()
	# UNFINISHED, different callbacks for different events
	for btn in buttons:
		if event_choice.type == 1:
			btn.connect("pressed", self, "_close_event_good")
		else:
			btn.connect("pressed", self, "_close_event")
