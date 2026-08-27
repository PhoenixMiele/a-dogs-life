extends CharacterBody2D

@export var speed: float = 200.0
@export var run_speed: float = 360.0
@export var deceleration: float = 10.0
@export var speed_change: float = 8.0
@onready var interaction_prompt: RichTextLabel = $InteractionPrompt
@onready var camera: Camera2D = $Camera2D

var movement_locked: bool = false
var nearby_interactables: Array[Node] = []
var interaction_in_progress: bool = false

func register_interactable(interactable: Node) -> void:
	if not nearby_interactables.has(interactable):
		nearby_interactables.append(interactable)

func unregister_interactable(interactable: Node) -> void:
	nearby_interactables.erase(interactable)

func set_movement_locked(locked: bool) -> void:
	movement_locked = locked

	if movement_locked:
		velocity.x = 0.0

func _physics_process(_delta: float) -> void:
	if movement_locked:
		velocity.x = 0.0
		move_and_slide()
		return
		
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
	
func _get_selected_interactable() -> Node:
	var selected: Node = null
	var highest_priority: int = -1
	var held_priority: int = -1

	for interactable in nearby_interactables:
		if interactable.holds_interaction_priority():
			held_priority = max(
				held_priority,
				interactable.get_interaction_priority()
			)

	for interactable in nearby_interactables:
		if interactable.can_interact():
			var priority: int = interactable.get_interaction_priority()

			if priority > held_priority and priority > highest_priority:
				highest_priority = priority
				selected = interactable

	return selected

func _process(_delta: float) -> void:
	if interaction_in_progress:
		interaction_prompt.visible = false
		return

	var selected_interactable := _get_selected_interactable()

	if selected_interactable:
		interaction_prompt.text = "[E] %s" % selected_interactable.get_interaction_text()
		interaction_prompt.visible = true

		if Input.is_action_just_pressed("investigate"):
			interaction_prompt.visible = false

			if selected_interactable.blocks_interaction():
				interaction_in_progress = true
				await selected_interactable.interact()
				interaction_in_progress = false
			else:
				selected_interactable.interact()
	else:
		interaction_prompt.visible = false
