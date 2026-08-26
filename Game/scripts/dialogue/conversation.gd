extends Node

signal completed
signal line_changed(line: DialogueLine)

var data: ConversationData
var participants: Dictionary = {}
var current_line_index: int = 0
var active: bool = false
var dog: Node = null

func start(
	conversation_data: ConversationData,
	runtime_participants: Dictionary
) -> void:
	if active:
		return

	data = conversation_data
	participants = runtime_participants
	dog = participants.get(&"dog")

	if (
		dog
		and data.presentation_mode == ConversationData.PresentationMode.FOCUSED
	):
		dog.set_movement_locked(true)
	
	current_line_index = 0
	active = true
	
	var line := get_current_line()

	if line:
		line_changed.emit(line)

func get_current_line() -> DialogueLine:
	if not active:
		return null

	if data == null:
		return null

	if current_line_index >= data.lines.size():
		return null

	return data.lines[current_line_index]

func advance() -> void:
	if not active:
		return

	current_line_index += 1

	if current_line_index < data.lines.size():
		var line := get_current_line()

		if line:
			line_changed.emit(line)
		
	if current_line_index >= data.lines.size():
		active = false

		if (
			dog
			and data.presentation_mode == ConversationData.PresentationMode.FOCUSED
		):
			dog.set_movement_locked(false)

		completed.emit()
		
func get_current_speaker() -> Node:
	var line := get_current_line()

	if line == null:
		return null

	if not participants.has(line.speaker_id):
		return null

	return participants[line.speaker_id]
