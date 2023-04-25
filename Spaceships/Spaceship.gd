extends KinematicBody2D

# Basic spaceship, Moves up/down/left/right.

var PlayerLaser = preload("res://Spaceships/Projectiles/PlayerLaser.tscn")
var EnemyLaser = preload("res://Spaceships/Projectiles/EnemyLaser.tscn")

enum States {NORMAL, DEAD, FINISHED}
onready var state = States.NORMAL

signal died()

enum Teams {PLAYER, ENEMY}
export (Teams) var team = Teams.PLAYER

onready var velocity = Vector2()
onready var direction = Vector2(1, 0)
onready var base_speed = 160

onready var health = 10

onready var shoot_cooldown_timer = $ShootCooldownTimer

func _process(delta):
	velocity.x = 0
	velocity.y = 0
	
	if team == Teams.PLAYER:
		if can_move():
			_player_movement(delta)
		if Input.is_action_just_pressed("shoot") and can_shoot():
			shoot()
	else:
		if can_move():
			pass # TODO AI movement here
	
	# Prevent diagonal movement
	if velocity.x != 0:
		velocity.y = 0
	
	# Rotation
	if velocity.x != 0 or velocity.y != 0:
		direction = Vector2(sign(velocity.x), sign(velocity.y))
		if direction != Vector2.ZERO:
			rotation = direction.angle() + PI / 2
	
	# State machine
	if state == States.NORMAL:
		_state_process_normal(delta)

func _player_movement(delta) -> void:
	if Input.is_action_pressed("move_down"):
		velocity.y += base_speed
	if Input.is_action_pressed("move_up"):
		velocity.y -= base_speed
	if Input.is_action_pressed("move_right"):
		velocity.x += base_speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= base_speed

func _state_process_normal(delta) -> void:
	if state == States.NORMAL:
		move_and_slide(velocity)
		
#		var new_position = global_position + velocity * delta
#		new_position.x = clamp(new_position.x, 0, 640)
#		new_position.y = clamp(new_position.y, -0, 360)
#		global_position = new_position

func can_move() -> bool:
	return state == States.NORMAL

func can_shoot() -> bool:
	return state == States.NORMAL and shoot_cooldown_timer.is_stopped()

func shoot() -> void:
	var shot = null
	if team == Teams.PLAYER:
		shot = PlayerLaser.instance()
	elif team == Teams.ENEMY:
		shot = EnemyLaser.instance()
	if shot == null:
		return
	shoot_cooldown_timer.start()
	get_parent().add_child(shot)
	shot.global_position = global_position
	shot.set_direction(direction)

func damage(amount: int, source: Node2D) -> void:
	health -= amount
	if health <= 0:
		health = 0
		die()

func die() -> void:
	if state != States.DEAD:
		state = States.DEAD
		hide()
		collision_layer = 0
		collision_mask = 0
		emit_signal("died")

func _on_ShootCooldownTimer_timeout():
	pass # Replace with function body.
