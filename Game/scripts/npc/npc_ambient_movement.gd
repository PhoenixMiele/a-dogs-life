extends Node
class_name NPCAmbientMovement

@onready var npc: Node2D = get_parent()
@export var movement_range: float = 100.0
@export var movement_speed: float = 40.0
@export var min_idle_time: float = 4.0
@export var max_idle_time: float = 8.0

var anchor_position: Vector2
var target_x: float
var is_moving: bool = false
var idle_timer: float = 0.0
var paused: bool = false

func _ready() -> void:
	anchor_position = npc.position
	idle_timer = randf_range(min_idle_time, max_idle_time)
	
func _process(delta: float) -> void:
	if paused:
		return
	if is_moving:
		npc.position.x = move_toward(
			npc.position.x,
			target_x,
			movement_speed * delta
		)
		
		if is_equal_approx(npc.position.x, target_x):
			is_moving = false
			idle_timer = randf_range(min_idle_time, max_idle_time)
		return

	idle_timer -= delta

	if idle_timer <= 0.0:
		_choose_new_target()

func _choose_new_target() -> void:
	target_x = randf_range(
		anchor_position.x - movement_range,
		anchor_position.x + movement_range
	)
	is_moving = true
	
func set_paused(value: bool) -> void:
	paused = value

	if not paused:
		idle_timer = randf_range(min_idle_time, max_idle_time)
		is_moving = false
