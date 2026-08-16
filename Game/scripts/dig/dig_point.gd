extends Area2D

signal dig_completed(dig_index: int)
@export var starts_available: bool = true
@export var max_digs: int = 1
@export var dig_duration: float = 4.0
@export var repeat_prompt_delay: float = 2.5

var available: bool = false
var dog_nearby: bool = false
var digging: bool = false
var exhausted: bool = false
var dig_count: int = 0
var dog: CharacterBody2D = null

func _ready() -> void:
	available = starts_available

func unlock() -> void:
	available = true

	if can_dig():
		$PromptLabel.visible = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Dog":
		dog = body
		dog_nearby = true

		if can_dig():
			$PromptLabel.visible = true
			
func _on_body_exited(body: Node2D) -> void:
	if body.name == "Dog":
		dog_nearby = false
		$PromptLabel.visible = false
		
		if not digging:
			dog = null
		
func can_dig() -> bool:
	return available and dog_nearby and not digging and not exhausted

func start_dig() -> void:
	if not can_dig():
		return

	digging = true
	$PromptLabel.visible = false
	
	if dog:
		dog.set_movement_locked(true)
	
	await get_tree().create_timer(dig_duration).timeout
		
	var completed_dig_index: int = dig_count
	dig_count += 1
	digging = false

	if dog:
		dog.set_movement_locked(false)

	dig_completed.emit(completed_dig_index)
	$HoleVisual.visible = true

	if dig_count >= max_digs:
		exhausted = true
		
	if can_dig():
		await get_tree().create_timer(repeat_prompt_delay).timeout

	if can_dig():
		$PromptLabel.visible = true
		
	if not dog_nearby:
		dog = null

func _process(_delta: float) -> void:
	if $PromptLabel.visible and dog:
		$PromptLabel.global_position = dog.global_position + Vector2(-45, -70)
	if can_dig() and Input.is_action_just_pressed("investigate"):
		start_dig()
