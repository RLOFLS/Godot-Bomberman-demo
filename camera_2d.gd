extends Camera2D
@onready var player := $"../Player"# 根据你的场景路径修改

var zoom_level := 3.0
var target_zoom := 3.0
const ZOOM_MIN := 1.0
const ZOOM_MAX := 3.0
const ZOOM_STEP := 0.2
const ZOOM_SPEED := 8.0  # 越大越快

var dragging := false
var drag_start := Vector2.ZERO
var camera_start := Vector2.ZERO

func _ready():
	make_current()  # 激活当前相机
	zoom = Vector2(zoom_level, zoom_level)

func _process(delta):
	# 平滑跟随玩家位置
	global_position = global_position.lerp(player.global_position, 1.0 - exp(-delta * 10))
	
	# 平滑缩放动画
	zoom_level = lerp(zoom_level, target_zoom, delta * ZOOM_SPEED)
	zoom = Vector2(zoom_level, zoom_level)
	
	if dragging:
		var current_mouse = get_viewport().get_mouse_position()
		var offset = drag_start - current_mouse
		position = camera_start + offset

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom - ZOOM_STEP, ZOOM_MIN, ZOOM_MAX)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom + ZOOM_STEP, ZOOM_MIN, ZOOM_MAX)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				dragging = true
				drag_start = get_viewport().get_mouse_position()
				camera_start = position
			else:
				dragging = false
