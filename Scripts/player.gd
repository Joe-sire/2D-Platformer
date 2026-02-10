extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var start_position = Vector2(512,256)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Forward") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0.1:
			animation.flip_h = true
		else:
			animation.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if is_on_floor():
		if velocity.x < -0.1:
			animation.play("run_2")
		elif velocity.x > 0.1:
			animation.play("run")
		else:
			animation.play("idle")
	else:
		animation.play("jump")

	# Handle Respawn
	if position.y > 832:
		# Set Position
		respawn()

func respawn():
	position = start_position
