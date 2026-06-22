extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float = 10000.0
@export var gravity: float = 980.0

var can_shoot: bool = true
var direction: int = 1

const ARROW_SCENE = preload("res://Scenes/arrow.tscn")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

	if is_on_wall():
		direction *= -1
		update_enemy_direction()

	if can_shoot and can_see_player():
		shoot()
		can_shoot = false
		await get_tree().create_timer(Globals.time_between_arrow).timeout
		can_shoot = true


func can_see_player() -> bool:
	var player = get_tree().get_first_node_in_group("Player")
	if not player:
		return false

	var space_state = get_world_2d().direct_space_state
	var eye_offset = Vector2(0, 10)

	var query = PhysicsRayQueryParameters2D.create(
		global_position + eye_offset, 
		player.global_position + eye_offset
	)

	query.exclude = [self.get_rid()]

	var result = space_state.intersect_ray(query)

	if result:
		return result.collider == player

	return false


func shoot() -> void:
	var projectile = ARROW_SCENE.instantiate()
	projectile.global_position = self.global_position + Vector2(0, -20)

	var throw_dir = Vector2.RIGHT if direction == 1 else Vector2.LEFT
	projectile.direction = throw_dir

	get_parent().add_child(projectile)


func update_enemy_direction() -> void:
	if sprite: 
		sprite.flip_h = (direction == -1)

	if animation: 
		animation.flip_h = (direction == -1)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Throwable":
		self.queue_free()
