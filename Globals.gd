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
