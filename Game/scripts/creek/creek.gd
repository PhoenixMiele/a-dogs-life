extends Node2D
signal investigations_completed
var completed_investigations: Array[String] = []
var investigations_are_complete: bool = false

func _on_investigation_completed(investigation_id: String) -> void:
	if investigation_id not in completed_investigations:
		completed_investigations.append(investigation_id)
		
	if _all_creek_investigations_complete() and not investigations_are_complete:
		investigations_are_complete = true
		investigations_completed.emit()
		
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

func _on_dig_point_dig_completed(dig_index: int) -> void:
	pass

func _on_scent_trail_trail_completed() -> void:
	$DigPoint2.unlock()
