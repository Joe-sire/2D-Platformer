extends Area2D

@export var speed: float = 600.0
@export var stuck_proj: bool = false
@export var can_damage = true

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	if global_position != Globals.player_position:
		direction = (Globals.player_position - global_position).normalized()
	else:
		direction = Vector2.RIGHT
	look_at(Globals.player_position)

func _process(delta: float) -> void:
	if not stuck_proj:
		position += direction * speed * delta

func _on_body_entered(_body: Node2D) -> void:
	if _body.name != "Player":
		_arrow_stick_to_wall()

func _arrow_stick_to_wall() -> void:
	stuck_proj = true
	can_damage = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	$StaticBody2D.collision_layer = 3
	await get_tree().create_timer(3.0).timeout
	self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not stuck_proj and body.name == "Player":
		self.queue_free()
	elif body.name == "Player":
		await get_tree().create_timer(0.15).timeout
		self.queue_free()
