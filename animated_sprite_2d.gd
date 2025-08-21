extends CharacterBody2D

enum CharacterState {
	IDLE,
	WALK,
	#RUN,
	#ATTACK,
	#JUMP
}

@export var SPEED: int = 200
var current_state := CharacterState.IDLE

@onready var anim_tree := $AnimationTree
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")


var direction: Vector2 = Vector2.ZERO

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var target_pos: Vector2
var is_nav: bool = false

# 预加载炸弹场景
var BombScene = preload("res://boom.tscn")

func _ready() -> void:
	velocity = Vector2.ZERO
	anim_tree.set_active(true)
	
	nav_agent.path_desired_distance = 10.0
	nav_agent.target_desired_distance = 10.0

func _process(delta: float) -> void:
	update_animation()
	
	if Input.is_action_just_pressed("ui_select"):  # 默认空格键是 ui_select
		place_bomb()

func _physics_process(delta):
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if direction != Vector2.ZERO:
		is_nav = false
	else:
		if is_nav:
			if nav_agent.is_navigation_finished():
				is_nav = false
				velocity = Vector2.ZERO
			if !nav_agent.is_navigation_finished():
				var next_pos = nav_agent.get_next_path_position()
				direction = (next_pos - global_position).normalized()
	
	
	velocity = direction * SPEED
		
	move_and_slide()

func update_animation():
	if direction != Vector2.ZERO:
		anim_tree["parameters/conditions/walk"] = true
		anim_tree["parameters/conditions/idle"] = false
		#print(direction)
	else:
		anim_tree["parameters/conditions/walk"] = false
		anim_tree["parameters/conditions/idle"] = true

	
	if direction != Vector2.ZERO:
		anim_tree.set("parameters/idle/blend_position", direction)
		anim_tree.set("parameters/walk/blend_position", direction)

func place_bomb():
	var bomb_instance = BombScene.instantiate()
	bomb_instance.position = self.position  # 设置炸弹位置为玩家当前位置
	var bomblayer := get_tree().get_first_node_in_group("BombLayer")
	bomblayer.add_child(bomb_instance)  # 添加到当前场景

func take_damage(amount):
	print("health -", amount)
