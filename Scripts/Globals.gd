extends Node

var pizza_start_position = Vector2()
var pizzas_left = 1
var player_position = Vector2()
var stuck: bool = false
var returning_to_player = false
var health = 8
var pizza = null
var max_health = 8
var time_between_arrow = 2.0
var on_fire: int = 0
