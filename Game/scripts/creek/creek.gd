extends Node2D
var completed_investigations: Array[String] = []

func _on_investigation_completed(investigation_id: String) -> void:
	if investigation_id not in completed_investigations:
		completed_investigations.append(investigation_id)
		
	print("Investigation completed: ", investigation_id)
	if _all_creek_investigations_complete():
		print("All creek investigations complete.")
		
func _all_creek_investigations_complete() -> bool:
	return (
		"creek_water_1" in completed_investigations
		and "creek_water_2" in completed_investigations
	)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
