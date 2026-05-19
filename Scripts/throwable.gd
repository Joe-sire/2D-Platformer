extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO
var pizza_current_position = self.global_position
var pizza_position_difference = Globals.pizza_start_position.distance_to(pizza_current_position)
var pizza_position_to_player_difference = pizza_current_position.distance_to(Globals.player_position)
var returning_to_start = false
const difference_value = 450

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pizza_current_position = self.position
	pizza_position_difference = Globals.pizza_start_position.distance_to(pizza_current_position)
	pizza_position_to_player_difference = pizza_current_position.distance_to($"../Player".global_position)
	if not Globals.stuck and not returning_to_start:
		position += direction * speed * delta
	if pizza_position_difference > difference_value and not returning_to_start:
		print("Coming Back")
		$StaticBody2D.collision_layer = 3
		returning_to_start = true

	if returning_to_start:
		Globals.stuck = false
		self.position.x = move_toward(self.position.x, Globals.pizza_start_position.x, speed/100)
		self.position.y = move_toward(self.position.y, Globals.pizza_start_position.y, speed/100)
	if returning_to_start and pizza_position_to_player_difference < 90 and Input.is_action_just_pressed("Throw"):
		Globals.pizzas_left += 1
		$StaticBody2D.collision_layer = 3
		returning_to_start = false
		Globals.stuck = false
		Globals.pizza_start_position = Vector2.ZERO
		pizza_current_position = Vector2.ZERO
		pizza_position_difference = Vector2.ZERO
		pizza_position_to_player_difference = Vector2.ZERO
		direction = Vector2.ZERO
		Globals.returning_to_player = false
		self.queue_free()
	if returning_to_start and pizza_position_difference == 0:
		await get_tree().create_timer(0.75).timeout
		Globals.returning_to_player = true
		returning_to_start = false
	if Globals.returning_to_player:
		Globals.stuck = false
		self.position.x = move_toward(self.position.x, Globals.player_position.x, 6)
		self.position.y = move_toward(self.position.y, Globals.player_position.y, 6)
		$"../CanvasLayer/Label".text = str(self.position)
		$"../CanvasLayer/Label2".text = str($"../Player".global_position)
	if Globals.returning_to_player and pizza_position_to_player_difference < 75:
		Globals.pizzas_left += 1
		$StaticBody2D.collision_layer = 3
		returning_to_start = false
		Globals.stuck = false
		Globals.pizza_start_position = Vector2.ZERO
		pizza_current_position = Vector2.ZERO
		pizza_position_difference = Vector2.ZERO
		pizza_position_to_player_difference = Vector2.ZERO
		direction = Vector2.ZERO
		Globals.returning_to_player = false
		self.queue_free()
func _on_body_entered(_body: Node2D) -> void:
	_stick_to_wall()

func _stick_to_wall() -> void:
	Globals.stuck = true
	$StaticBody2D.collision_layer = 3
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
