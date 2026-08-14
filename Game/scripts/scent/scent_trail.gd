extends Node2D

@onready var route: Node2D = $Route
var route_points: Array[Node] = []
var current_point_index: int = 0
var active: bool = false

func _ready() -> void:
	route_points = route.get_children()

	for point in route_points:
		point.dog_reached.connect(_on_point_reached.bind(point))

func activate(
	_scent_position: Vector2,
	_scent_type: String,
	_duration: float,
	_colour: Color,
	creates_trail: bool
) -> void:
	if not creates_trail:
		return

	active = true
	current_point_index = 0
	print("Scent trail activated")

func _on_point_reached(point: Node) -> void:
	if not active:
		return
		
	if current_point_index >= route_points.size():
		return

	if route_points[current_point_index] != point:
		return

	print("Reached expected route point: ", point.name)

	current_point_index += 1

	if current_point_index >= route_points.size():
		print("Scent trail complete")
