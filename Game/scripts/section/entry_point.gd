extends Marker2D

@export var entry_id: StringName

func _ready() -> void:
	add_to_group("entry_point")
