extends CharacterBody2D
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpsound: AudioStreamPlayer = $jumpsound
@onready var deathsound: AudioStreamPlayer = $deathsound
const CLOUD_EFFECT = preload("res://Scenes/gpu_particles_2d.tscn")
const MAX_SPEED = 290.0
const ACCELERATION = 1400.0
const FRICTION = 1500.0
const TURN_FACTOR = 0.73
const AIR_CONTROL_FACTOR = 0.45
const JUMP_VELOCITY = -400.0
const THROWABLE_SCENE = preload("res://Scenes/throwable.tscn")
const gravity = 700
var start_position = Vector2()

func _ready():
	start_position = self.global_position

func _physics_process(delta: float) -> void:
	# Track player position globally for other systems to reference
	Globals.player_position = self.global_position

	# Apply gravity while airborne
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump input
	if Input.is_action_just_pressed("Forward"):
		try_jump()

	# Horizontal movement with acceleration, deceleration, turn-around penalty, and reduced air control
	var direction := Input.get_axis("Left", "Right")
	var on_floor := is_on_floor()
	if direction:
		var current_accel := ACCELERATION
		if on_floor:
			if velocity.x != 0 and sign(velocity.x) != sign(direction):
				current_accel = ACCELERATION * TURN_FACTOR
		else:
			current_accel = ACCELERATION * AIR_CONTROL_FACTOR
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, current_accel * delta)
		animation.flip_h = direction < 0
	else:
		var current_friction := FRICTION
		if not on_floor:
			current_friction *= AIR_CONTROL_FACTOR
		velocity.x = move_toward(velocity.x, 0, current_friction * delta)

	# Handle throw input
	if Input.is_action_just_pressed("Throw"):
		throw()

	# Apply movement and update visuals/state
	move_and_slide()
	_update_animations(direction)

	# Fall-death check
	if position.y > 832:
		damage()

func try_jump():
	# Only allow jumping when grounded
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpsound.play()

func _spawn_cloud():
	# Spawns a one-off particle effect at the player's feet
	var cloud = CLOUD_EFFECT.instantiate()
	cloud.global_position = global_position + Vector2(0, -8) 
	get_parent().add_child(cloud)
	cloud.scale = Vector2(0.5, 0.5)

func _update_animations(direction):
	# Picks the correct animation based on movement and ground state
	if is_on_floor():
		animation.play("run" if direction != 0 else "idle")
	else:
		animation.play("jump")

func throw():
	# Spawns and launches a pizza projectile if any are available,
	# otherwise triggers the "returning" logic if one is stuck out in the world
	if Globals.pizzas_left > 0:
		Globals.pizzas_left = Globals.pizzas_left - 1
		Globals.pizza_start_position = Vector2(position.x, position.y)
		var projectile = THROWABLE_SCENE.instantiate()
		projectile.global_position = self.global_position + Vector2(0, 20)
		var throw_dir = Vector2.LEFT if animation.flip_h else Vector2.RIGHT
		projectile.direction = throw_dir
		get_parent().add_child(projectile)
	elif Globals.stuck:
		Globals.returning_to_player = true

func _on_hit(area) -> void:
	# Handles collisions with hazards/enemies and applies damage if valid
	if area.is_in_group("Enemy"):
		area = area.get_parent()
	if area.get("can_damage") == true:
		if area.is_in_group("Enemy"):
			area.hit_player()
		damage()

func damage():
	# Reduces health, or resets the scene if the player has run out
	if Globals.health <= 1:
		deathsound.play()
		Globals.health = Globals.max_health
		Globals.pizzas_left = 1
		get_tree().reload_current_scene()
	else:
		Globals.health -= 1

func _on_timer_timeout() -> void:
	# Applies recurring fire damage over time while the "on fire" status is active
	if Globals.on_fire > 0:
		damage()
		Globals.on_fire -= 1
