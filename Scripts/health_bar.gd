extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Globals.health == 8:
		$Sprite2D2.show()
		$Sprite2D3.show()
		$Sprite2D4.show()
		$Sprite2D5.show()
		$Sprite2D6.show()
		$Sprite2D7.show()
		$Sprite2D8.show()
		$Sprite2D9.show()
	if Globals.health == 7:
		$Sprite2D2.show()
		$Sprite2D3.show()
		$Sprite2D4.show()
		$Sprite2D5.show()
		$Sprite2D6.show()
		$Sprite2D7.show()
		$Sprite2D8.show()
		$Sprite2D9.hide()
	if Globals.health == 6:
		$Sprite2D2.show()
		$Sprite2D3.show()
		$Sprite2D4.show()
		$Sprite2D5.show()
		$Sprite2D6.show()
		$Sprite2D7.show()
		$Sprite2D8.hide()
		$Sprite2D9.hide()
	if Globals.health == 5:
		$Sprite2D2.show()
		$Sprite2D3.show()
		$Sprite2D4.show()
		$Sprite2D5.show()
		$Sprite2D6.show()
		$Sprite2D7.hide()
		$Sprite2D8.hide()
		$Sprite2D9.hide()
	if Globals.health == 4:
		$Sprite2D2.show()
		$Sprite2D3.show()
		$Sprite2D4.show()
		$Sprite2D5.show()
		$Sprite2D6.hide()
		$Sprite2D7.hide()
		$Sprite2D8.hide()
		$Sprite2D9.hide()
	if Globals.health == 3:
		$Sprite2D2.show()
		$Sprite2D3.show()
		$Sprite2D4.show()
		$Sprite2D5.hide()
		$Sprite2D6.hide()
		$Sprite2D7.hide()
		$Sprite2D8.hide()
		$Sprite2D9.hide()
	if Globals.health == 2:
		$Sprite2D2.show()
		$Sprite2D3.show()
		$Sprite2D4.hide()
		$Sprite2D5.hide()
		$Sprite2D6.hide()
		$Sprite2D7.hide()
		$Sprite2D8.hide()
		$Sprite2D9.hide()
	if Globals.health == 1:
		$Sprite2D2.show()
		$Sprite2D3.hide()
		$Sprite2D4.hide()
		$Sprite2D5.hide()
		$Sprite2D6.hide()
		$Sprite2D7.hide()
		$Sprite2D8.hide()
		$Sprite2D9.hide()
	if Globals.health == 0:
		$Sprite2D2.hide()
		$Sprite2D3.hide()
		$Sprite2D4.hide()
		$Sprite2D5.hide()
		$Sprite2D6.hide()
		$Sprite2D7.hide()
		$Sprite2D8.hide()
		$Sprite2D9.hide()

	if Globals.health > 8:
		Globals.health = 8
	
	if Globals.health < 0:
		Globals.health = 0
