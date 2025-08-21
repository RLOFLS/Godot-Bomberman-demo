extends Area2D

@onready var animationPlayer = $AnimationPlayer
@export var explosion_range := 3  # 爆炸长度，影响十字架长度
@onready var timer := $Timer
@onready var collisionShape := $StaticBody2D/CollisionShape2D

var already_exploded = false

func _ready() -> void: 
	animationPlayer.play("default")
	timer.start()

func explode():
	if already_exploded: return
	already_exploded = true
	spawn_explosion_area()
	queue_free() 
	 # 炸弹本体消失

func spawn_explosion_area():
	var bomblayer := get_tree().current_scene 
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	for dir in directions:
		for i in range(1, explosion_range + 1):
			var explosion = preload("res://explosion_area.tscn").instantiate()
			explosion.position = self.position + dir * i * 16  # 假设每格是32像素
			bomblayer.add_child(explosion)

	# 中心爆炸也要加上
	var center_explosion = preload("res://explosion_area.tscn").instantiate()
	center_explosion.position = self.position
	bomblayer.add_child(center_explosion)


func _on_timer_timeout() -> void:
	explode()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		collisionShape.call_deferred("set_disabled", false)
