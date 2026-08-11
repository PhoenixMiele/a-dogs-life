extends Area2D
signal investigated(investigation_id: String)

var dog_nearby: bool = false
var has_been_investigated: bool = false
var dog: Node2D = null

@export_multiline var investigation_text: String = ""
@onready var interaction_prompt: Label = $InteractionPrompt
@onready var investigation_label: RichTextLabel = $InvestigationText
@export var text_display_duration: float = 5.0
@export var investigation_id: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("dog"):
		dog = body
		dog_nearby = true
		if not has_been_investigated:
			interaction_prompt.show()
					
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("dog"):
		dog_nearby = false
		interaction_prompt.hide()
		if not investigation_label.visible:
			dog = null

func _process(_delta: float) -> void:
	if investigation_label.visible and dog:
		investigation_label.global_position = dog.global_position + Vector2(-60, -100)
	if interaction_prompt.visible and dog:
		interaction_prompt.global_position = dog.global_position + Vector2(-45, -70)
	
	if dog_nearby and Input.is_action_just_pressed("investigate"):
		for point in get_tree().get_nodes_in_group("investigation_point"):
			point.hide_investigation_text()
		has_been_investigated = true
		investigated.emit(investigation_id)
		interaction_prompt.hide()
		investigation_label.text = "[i]%s[/i]" % investigation_text
		investigation_label.global_position = dog.global_position + Vector2(-60, -100)
		investigation_label.show()
		
		await get_tree().create_timer(text_display_duration).timeout
		investigation_label.hide()

func hide_investigation_text() -> void:
	investigation_label.hide()
