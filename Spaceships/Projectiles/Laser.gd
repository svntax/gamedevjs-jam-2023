extends Area2D

# Basic bullet. Moves in a straight line.

onready var velocity = Vector2()
onready var direction = Vector2(1, 0)
onready var base_speed = 220

onready var damage = 1
onready var active = true

func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	self.connect("area_entered", self, "_on_area_entered")

func set_direction(dir: Vector2) -> void:
	direction = dir
	velocity = direction * base_speed

func _physics_process(delta):
	global_position += velocity * delta
	rotation = velocity.angle()

func _on_body_entered(other):
	if not active:
		return
	
	if other.has_method("damage"):
		active = false
		other.damage(1, self)
		queue_free()

func _on_area_entered(other):
	if not active:
		return
	
	if other.has_method("damage"):
		active = false
		other.damage(1, self)
		queue_free()

func damage(amount: int, source: Node2D) -> void:
	active = false
	queue_free()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	active = false
	queue_free()
