extends Area2D

func _on_body_entered(body):
	if body.has_method("update_max_jumps"):
		body.update_max_jumps(10)
		body.get_node("jumpchange").play()
