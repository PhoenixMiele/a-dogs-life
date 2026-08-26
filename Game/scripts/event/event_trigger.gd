extends Area2D

signal triggered

@export var event_id: StringName
@export var one_shot: bool = true

var has_triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if one_shot and ActState.has_state(event_id):
		var state: Dictionary = ActState.get_state(event_id)
		has_triggered = state.get("triggered", false)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("dog"):
		return

	if one_shot and has_triggered:
		return

	has_triggered = true

	if one_shot:
		ActState.set_state(event_id, {
			"triggered": true
		})

	triggered.emit()
