extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Globals.pizzas_left == 1:
		$Sprite2D.show()
	else:
		$Sprite2D.hide()
