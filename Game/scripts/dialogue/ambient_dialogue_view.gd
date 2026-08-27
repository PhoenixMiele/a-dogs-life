extends Node

@onready var dialogue_label: RichTextLabel = $DialogueLabel
@export var speaker_offset: Vector2 = Vector2(-120, -100)

var conversation: Node = null
var current_speaker: Node = null

func setup(runtime_conversation: Node) -> void:
	conversation = runtime_conversation
	conversation.line_changed.connect(_on_line_changed)
	conversation.completed.connect(_on_conversation_completed)

func _on_conversation_completed() -> void:
	dialogue_label.visible = false
	current_speaker = null

func _on_line_changed(line: DialogueLine) -> void:
	if (
		conversation.data.presentation_mode
		!= ConversationData.PresentationMode.AMBIENT
	):
		return

	var speaker: Node = conversation.get_current_speaker()

	if speaker == null:
		return
	
	current_speaker = speaker
	
	dialogue_label.global_position = speaker.global_position + speaker_offset
	dialogue_label.text = line.text
	dialogue_label.visible = true
	
func _process(_delta: float) -> void:
	if current_speaker == null:
		return

	if not dialogue_label.visible:
		return

	dialogue_label.global_position = current_speaker.global_position + speaker_offset
