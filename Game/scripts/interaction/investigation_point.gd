extends Area2D
signal investigated(investigation_id: String)

var dog_nearby: bool = false
var dog: Node2D = null
var investigation_count: int = 0
var investigated_this_visit: bool = false

@export_multiline var investigation_text: String = ""
@export var repeat_investigation_texts: Array[String] = []
@onready var interaction_prompt: Label = $InteractionPrompt
@onready var investigation_label: RichTextLabel = $InvestigationText
@export var text_display_duration: float = 5.0
@export var investigation_id: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("dog"):
		dog = body
		dog_nearby = true
		if _has_available_investigation_text():
			interaction_prompt.show()
					
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("dog"):
		dog_nearby = false
		investigated_this_visit = false
		interaction_prompt.hide()
		if not investigation_label.visible:
			dog = null

func _process(_delta: float) -> void:
	if investigation_label.visible and dog:
		investigation_label.global_position = dog.global_position + Vector2(-60, -100)
	if interaction_prompt.visible and dog:
		interaction_prompt.global_position = dog.global_position + Vector2(-45, -70)
	
	if dog_nearby and not investigated_this_visit and _has_available_investigation_text() and Input.is_action_just_pressed("investigate"):
		for point in get_tree().get_nodes_in_group("investigation_point"):
			point.hide_investigation_text()
		investigated.emit(investigation_id)
		interaction_prompt.hide()
		investigation_label.text = "[i]%s[/i]" % _get_current_investigation_text()
		investigation_label.global_position = dog.global_position + Vector2(-60, -100)
		investigation_label.show()
		investigation_count += 1
		investigated_this_visit = true
		await get_tree().create_timer(text_display_duration).timeout
		investigation_label.hide()
		if not dog_nearby:
			dog = null

func hide_investigation_text() -> void:
	investigation_label.hide()
	
func _get_current_investigation_text() -> String:
	if investigation_count == 0:
		return investigation_text

	var repeat_index: int = investigation_count - 1
	return repeat_investigation_texts[repeat_index]
	
func _has_available_investigation_text() -> bool:
	return investigation_count <= repeat_investigation_texts.size()
