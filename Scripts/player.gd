extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpsound: AudioStreamPlayer = $jumpsound
@onready var deathsound: AudioStreamPlayer = $deathsound

const CLOUD_EFFECT = preload("res://Scenes/gpu_particles_2d.tscn")
const SPEED = 14000.0
const JUMP_VELOCITY = -400.0
const THROWABLE_SCENE = preload("res://Scenes/throwable.tscn")
const gravity = 700
var start_position = Vector2(288, 592)

func _ready():
	pass

func _physics_process(delta: float) -> void:
	Globals.player_position = self.global_position

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Forward"):
		try_jump()

	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED * delta
		animation.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("Throw"):
		throw()

	move_and_slide()
	_update_animations(direction)

	if position.y > 832:
		respawn()

func try_jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpsound.play()


func _spawn_cloud():
	var cloud = CLOUD_EFFECT.instantiate()
	cloud.global_position = global_position + Vector2(0, -8) 
	get_parent().add_child(cloud)
	cloud.scale = Vector2(0.5, 0.5)

func _update_animations(direction):
	if is_on_floor():
		animation.play("run" if direction != 0 else "idle")
	else:
		animation.play("jump")

func throw():
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

func respawn():
	deathsound.play()
	position = start_position
	velocity = Vector2.ZERO
