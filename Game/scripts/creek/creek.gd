extends Node2D
signal investigations_completed
var completed_investigations: Array[StringName] = []
var investigations_are_complete: bool = false

func _on_investigation_completed(investigation_id: StringName) -> void:
	if investigation_id not in completed_investigations:
		completed_investigations.append(investigation_id)
		
	if _all_creek_investigations_complete() and not investigations_are_complete:
		investigations_are_complete = true
		investigations_completed.emit()
		
func _all_creek_investigations_complete() -> bool:
	return (
		&"Creek_Investigate_001" in completed_investigations
		and &"Creek_Investigate_002" in completed_investigations
	)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_reload_scene"):
		get_tree().reload_current_scene()
		
func _on_dig_point_dig_completed(dig_index: int) -> void:
	pass

func _on_scent_trail_trail_completed() -> void:
	$DigPoint2.unlock()

func _ready() -> void:
	pass
