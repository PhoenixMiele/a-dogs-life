extends Area2D

signal dog_reached

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("dog"):
		dog_reached.emit()
