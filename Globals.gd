extends Node

#const CONTRACT_NAME = "dev-1682499174497-98587853425976"
const CONTRACT_NAME = "dev-1682511766172-84139316992322"
var wallet_connection = null

enum Faction {SQUARE, CIRCLE, TRIANGLE}

var current_support_count: int = 0 setget set_support_count, get_support_count

func set_support_count(amount: int) -> void:
	if amount >= 1 and amount <= 1000:
		current_support_count = amount

func get_support_count() -> int:
	return current_support_count

# Blockchain data
var supporters_square = 0
var supporters_circle = 0
var supporters_triangle = 0

var event_random_message = {
	"labels": [
		"Your sensors pick up a message left behind by another traveler."
	],
	"buttons": [
		"Read Message",
		"Ignore"
	],
	"type": 4
}

var event_free_support = {
	"labels": [
		"You find an outpost with some travelers eager to join your cause!"
	],
	"buttons": [
		"Recruit",
	],
	"type": 1
}

var event_asteroid_field = {
	"labels": [
		"An asteroid field comes into view! It seems like a good place to gather resources"
	],
	"buttons": [
		"Visit (UNFINISHED)",
	],
	"type": 2
}

var event_enemies = {
	"labels": [
		"Some hostile travelers have appeared!"
	],
	"buttons": [
		"Fight (UNFINISHED)",
		"Run Away (UNFINISHED)"
	],
	"type": 3
}

var events = [
	event_random_message,
	event_free_support,
	event_asteroid_field,
	event_enemies
]
func get_random_event():
	var choice = randi() % events.size()
	var ev = events[choice]
	return ev
