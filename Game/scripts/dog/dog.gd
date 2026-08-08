extends CharacterBody2D

@export var speed: float = 200.0
@export var run_speed: float = 360.0
@export var deceleration: float = 10.0
@export var speed_change: float = 8.0

func _physics_process(_delta: float) -> void:
	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	var current_speed := speed
	if Input.is_action_pressed("run"):
		current_speed = run_speed
	if direction:
		velocity.x = move_toward(velocity.x, direction * current_speed, speed_change)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)

	move_and_slide()
