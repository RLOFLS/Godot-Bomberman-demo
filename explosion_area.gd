extends Area2D

@onready var timer := $Timer

func _ready():
	timer.start()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)  # 或根据需要调整伤害值 

func _on_Timer_timeout():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bomb") and area.has_method("explode"):
		area.call_deferred("explode")  # 或根据需要调整伤害值
