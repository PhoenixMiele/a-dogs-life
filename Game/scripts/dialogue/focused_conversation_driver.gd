extends Node

var conversation: Node = null

func setup(runtime_conversation: Node) -> void:
	conversation = runtime_conversation

func _unhandled_input(event: InputEvent) -> void:
	if conversation == null:
		return

	if not conversation.active:
		return

	if (
		conversation.data.presentation_mode
		!= ConversationData.PresentationMode.FOCUSED
	):
		return

	if event.is_action_pressed("investigate"):
		conversation.advance()
