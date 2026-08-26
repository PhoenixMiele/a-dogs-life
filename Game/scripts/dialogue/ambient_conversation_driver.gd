extends Node

@export var seconds_per_five_words: float = 2.0

var conversation: Node = null

func setup(runtime_conversation: Node) -> void:
	conversation = runtime_conversation
	conversation.line_changed.connect(_on_line_changed)
	
func _on_line_changed(line: DialogueLine) -> void:
	if (
		conversation.data.presentation_mode
		!= ConversationData.PresentationMode.AMBIENT
	):
		return	
	
	var word_count: int = line.text.split(" ", false).size()
	var duration: float = max(
		(float(word_count) / 5.0) * seconds_per_five_words,
		seconds_per_five_words
	)

	await get_tree().create_timer(duration).timeout

	if conversation and conversation.active:
		conversation.advance()
