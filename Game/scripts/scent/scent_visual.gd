extends Node2D

@export_enum("isolated", "faint", "strong") var scent_type: String = "isolated"
@export var duration: float = 5.0
@export var colour: Color = Color.WHITE
@export var persistent: bool = false

@onready var scent_blobs: Array[Polygon2D] = [
	$ScentBlob1,
	$ScentBlob2,
	$ScentBlob3
]

func _ready() -> void:
	for scent_blob in scent_blobs:
		var display_colour: Color = colour
		display_colour.a = scent_blob.color.a
		scent_blob.color = display_colour
		
	_apply_scent_type()
	_start_lifetime()
	
func _apply_scent_type() -> void:
	var scent_alpha: float
	var scent_scale: float

	match scent_type:
		"faint":
			scent_alpha = 0.25
			scent_scale = 0.8
		"isolated":
			scent_alpha = 0.5
			scent_scale = 1.0
		"strong":
			scent_alpha = 0.8
			scent_scale = 1.2

	scale = Vector2(scent_scale, scent_scale)

	for scent_blob in scent_blobs:
		scent_blob.color.a = scent_alpha
	
func _start_lifetime() -> void:
	if persistent:
		return
	
	await get_tree().create_timer(duration).timeout
	queue_free()
