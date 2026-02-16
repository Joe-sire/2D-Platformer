extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpsound: AudioStreamPlayer = $jumpsound
@onready var deathsound: AudioStreamPlayer = $deathsound

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const COYOTE_DURATION = 0.15 # Grace period in seconds

# Changed these to variables so they can be modified mid-level
var max_extra_jumps := 2 
var extra_jumps_left := 2
var coyote_timer := 0.5
var start_position = Vector2(512, 256)

signal jumps_changed(new_current, new_max)

func _ready():
	# Update UI with initial values
	jumps_changed.emit(extra_jumps_left, max_extra_jumps)

func _physics_process(delta: float) -> void:
	# 1. Gravity & Coyote Timer Logic
	if is_on_floor():
		coyote_timer = COYOTE_DURATION
		# Reset jumps when touching the ground
		if extra_jumps_left != max_extra_jumps:
			extra_jumps_left = max_extra_jumps
			jumps_changed.emit(extra_jumps_left, max_extra_jumps)
	else:
		velocity += get_gravity() * delta
		coyote_timer -= delta # Count down the grace period

	# 2. Handle Jump Input
	if Input.is_action_just_pressed("Forward"):
		_try_jump()

	# 3. Horizontal Movement
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		animation.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_update_animations(direction)

	if position.y > 832:
		respawn()

func _try_jump():
	# If timer > 0, we treat it as a floor jump
	if coyote_timer > 0:
		_do_jump()
		coyote_timer = 0 # Disable coyote time until next floor touch
	elif extra_jumps_left > 0:
		extra_jumps_left -= 1
		jumps_changed.emit(extra_jumps_left, max_extra_jumps)
		_do_jump()

func _do_jump():
	velocity.y = JUMP_VELOCITY
	jumpsound.play()

# Call this from an Area2D to increase the jump limit
func update_max_jumps(amount: int):
	max_extra_jumps = amount
	extra_jumps_left = max_extra_jumps
	jumps_changed.emit(extra_jumps_left, max_extra_jumps)

func _update_animations(direction):
	if is_on_floor():
		animation.play("run" if direction != 0 else "idle")
	else:
		animation.play("jump")

func respawn():
	deathsound.play()
	position = start_position
	velocity = Vector2.ZERO
