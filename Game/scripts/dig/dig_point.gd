extends Area2D

signal dig_completed(dig_index: int)
@export var starts_available: bool = true
@export var max_digs: int = 1
@export var dig_duration: float = 4.0

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

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("dog"):		
		dog = body
		dog.register_interactable(self)
		dog_nearby = true
			
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("dog"):		
		dog_nearby = false
		dog.unregister_interactable(self)
		
		if not digging:
			dog = null
		
func can_dig() -> bool:
	return available and dog_nearby and not digging and not exhausted

func can_interact() -> bool:
	return can_dig()

func get_interaction_text() -> String:
	return "Dig"

func get_interaction_priority() -> int:
	return 50

func interact() -> void:
	await start_dig()

func blocks_interaction() -> bool:
	return true

func holds_interaction_priority() -> bool:
	return false

func start_dig() -> void:
	if not can_dig():
		return

	digging = true	
	
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

	if not dog_nearby:
		dog = null
