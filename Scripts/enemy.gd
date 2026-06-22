extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 980.0
@export var can_damage = true

var direction: int = 1

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = direction * speed

	move_and_slide()

	if is_on_wall():
		direction *= -1
		update_enemy_direction()

func update_enemy_direction() -> void:
	sprite.flip_h = (direction == -1)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Throwable":
		self.queue_free()

func hit_player():
	can_damage = false
	$Timer.start(1.0)

func _on_timer_timeout() -> void:
	can_damage = true
	for i in $Area2D.get_overlapping_areas():
		if i.is_in_group("Player_Area"):
			i.get_parent()._on_hit($Area2D)
