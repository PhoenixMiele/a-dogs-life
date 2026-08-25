extends Node

var destination_entry_id: StringName

func transition_to(destination_scene: String, entry_id: StringName) -> void:
	destination_entry_id = entry_id
	get_tree().call_deferred("change_scene_to_file", destination_scene)

func _ready() -> void:
	get_tree().tree_changed.connect(_on_tree_changed)

func _on_tree_changed() -> void:
	if destination_entry_id == &"":
		return

	var dog := get_tree().get_first_node_in_group("dog")
	if dog == null:
		return

	for entry_point in get_tree().get_nodes_in_group("entry_point"):
		if entry_point.entry_id == destination_entry_id:
			dog.global_position = entry_point.global_position

			destination_entry_id = &""
			return
