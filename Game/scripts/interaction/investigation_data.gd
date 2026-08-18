class_name InvestigationData
extends Resource

@export_multiline var text: String = ""
@export var has_scent: bool = false
@export_enum("isolated", "faint", "strong") var scent_type: String = "isolated"
@export var scent_duration: float = 5.0
@export var scent_colour: Color = Color.WHITE
@export var creates_trail: bool = false
