extends GPUParticles2D

func _ready():
	emitting = true
	# Wait for the particles to finish, then delete the node
	await get_tree().create_timer(lifetime).timeout
	queue_free()
