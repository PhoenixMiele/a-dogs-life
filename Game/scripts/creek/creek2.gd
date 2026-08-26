extends Node2D

func _on_event_trigger_test_triggered() -> void:
	$EventTestVisual.visible = true

func _on_conversation_interactor_test_conversation_completed(
	_conversation_index: int
) -> void:
	pass
