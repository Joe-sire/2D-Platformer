extends ProgressBar

@export var player: CharacterBody2D 

func _ready():
	if player:
		player.jumps_changed.connect(_on_jumps_updated)

func _on_jumps_updated(current, max_val):
	max_value = max_val
	value = current
