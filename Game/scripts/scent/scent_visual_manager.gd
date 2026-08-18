extends Node2D

const SCENT_VISUAL_SCENE: PackedScene = preload("res://scenes/scent/ScentVisual.tscn")
var persistent_scent_visual: Node2D = null

func _create_scent_visual(
	scent_position: Vector2,
	scent_type: String,
	duration: float,
	colour: Color,
	persistent: bool
) -> Node2D:
	var scent_visual = SCENT_VISUAL_SCENE.instantiate()

	scent_visual.scent_type = scent_type
	scent_visual.duration = duration
	scent_visual.colour = colour
	scent_visual.persistent = persistent

	add_child(scent_visual)
	scent_visual.global_position = scent_position

	return scent_visual

func show_scent(
	scent_position: Vector2,
	scent_type: String,
	duration: float,
	colour: Color,
	creates_trail: bool
) -> void:
	if creates_trail:
		return

	_create_scent_visual(
		scent_position,
		scent_type,
		duration,
		colour,
		false
	)

func show_persistent_scent(
	scent_position: Vector2,
	scent_type: String,
	duration: float,
	colour: Color
) -> void:
	persistent_scent_visual = _create_scent_visual(
		scent_position,
		scent_type,
		duration,
		colour,
		true
	)

func show_trail_scent(
	scent_position: Vector2,
	scent_type: String,
	duration: float,
	colour: Color
) -> void:
	var scent_visual = _create_scent_visual(
		scent_position,
		scent_type,
		duration,
		colour,
		false
	)

	scent_visual.modulate.a = 0.7

func clear_persistent_scent() -> void:
	if is_instance_valid(persistent_scent_visual):
		persistent_scent_visual.queue_free()

	persistent_scent_visual = null
