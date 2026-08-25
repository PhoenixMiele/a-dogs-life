extends Area2D

@export_file("*.tscn") var destination_scene: String
@export var destination_entry_id: StringName

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("dog"):
		return

	if destination_scene.is_empty():
		return

	SectionManager.transition_to(
		destination_scene,
		destination_entry_id
	)
