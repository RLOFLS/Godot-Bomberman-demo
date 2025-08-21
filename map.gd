extends Node2D

@onready var player = $"../Player"

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var click_pos = get_global_mouse_position()
		
		print(click_pos)
		
		player.is_nav = true
		player.target_pos = click_pos
		player.nav_agent.target_position = click_pos
