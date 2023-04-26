extends Node2D

var EventMenu = preload("res://UI/Events/EventMenu.tscn")
onready var event_root = $UI/EventRoot
onready var event_timer = $EventTimer

var Star = preload("res://SpaceFields/Star.tscn")
onready var stars_root = $Stars

onready var player_ship = $PlayerShip

func _ready():
	for i in range(800):
		var x = rand_range(0, 640)
		var y = rand_range(0, 360)
		var star = Star.instance()
		stars_root.add_child(star)
		star.global_position = Vector2(x, y)
	
	setup_story()

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
	start_travel()

func start_random_event() -> void:
	stop_travel()
	
	var event = EventMenu.instance()
	event_root.add_child(event)
	event.clear_pages()
	var buttons = event.add_page("EVENT", [
		"This is a random event"
	],
	[
		"Ok"
	])
	event.current_page = 0
	yield(get_tree(), "idle_frame")
	event.update_current_page()
	buttons[0].connect("pressed", self, "_start_game")
