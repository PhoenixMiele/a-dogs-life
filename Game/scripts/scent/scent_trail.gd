extends Node2D
const SCENT_VISUAL_SCENE: PackedScene = preload("res://scenes/scent/ScentVisual.tscn")
signal trail_completed

@onready var route: Node2D = $Route
@export var scent_visual_manager: Node
var route_points: Array[Node] = []
var current_point_index: int = 0
var active: bool = false
var completed: bool = false
var trail_scent_type: String = "isolated"
var trail_duration: float = 5.0
var trail_colour: Color = Color.WHITE

func _ready() -> void:
	route_points = route.get_children()

	for point in route_points:
		point.dog_reached.connect(_on_point_reached.bind(point))

func activate(
	_scent_position: Vector2,
	scent_type: String,
	duration: float,
	colour: Color,
	creates_trail: bool
) -> void:
	if completed:
		return
	if active:
		return
	if not creates_trail:
		return
	if scent_visual_manager:
		scent_visual_manager.show_persistent_scent(
			_scent_position,
			scent_type,
			duration,
			colour
		)
	
	trail_scent_type = scent_type
	trail_duration = duration
	trail_colour = colour

	active = true
	current_point_index = 0
	if not route_points.is_empty():
		_show_scent_at(route_points[current_point_index])
	print("Scent trail activated")

func _show_scent_at(point: Node2D) -> void:
	var scent_visual = SCENT_VISUAL_SCENE.instantiate()

	scent_visual.scent_type = trail_scent_type
	scent_visual.duration = trail_duration
	scent_visual.colour = trail_colour
	
	scent_visual.modulate.a = 0.7
	add_child(scent_visual)
	scent_visual.global_position = point.global_position

func _on_point_reached(point: Node) -> void:
	if not active:
		return
		
	if current_point_index >= route_points.size():
		return

	if route_points[current_point_index] != point:
		return

	print("Reached expected route point: ", point.name)
	current_point_index += 1
	if current_point_index < route_points.size():
		_show_scent_at(route_points[current_point_index])

	if current_point_index >= route_points.size():
		active = false
		completed = true
		trail_completed.emit()
		
		if scent_visual_manager:
			scent_visual_manager.clear_persistent_scent()
		print("Scent trail complete")
		
func on_source_reentered(body: Node2D) -> void:
	if not active:
		return

	if not body.is_in_group("dog"):
		return

	current_point_index = 0

	if not route_points.is_empty():
		_show_scent_at(route_points[current_point_index])


func _on_investigation_point_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
