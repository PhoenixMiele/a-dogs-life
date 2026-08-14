extends Node2D

const SCENT_VISUAL_SCENE: PackedScene = preload("res://scenes/scent/ScentVisual.tscn")

func show_scent(
	scent_position: Vector2,
	scent_type: String,
	duration: float,
	colour: Color,
	creates_trail: bool
) -> void:
	var scent_visual = SCENT_VISUAL_SCENE.instantiate()
	scent_visual.scent_type = scent_type
	scent_visual.duration = duration
	scent_visual.colour = colour
	add_child(scent_visual)
	scent_visual.global_position = scent_position
