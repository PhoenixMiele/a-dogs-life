class_name ConversationData
extends Resource

enum PresentationMode {
	AMBIENT,
	FOCUSED
}

@export var conversation_id: StringName
@export var presentation_mode: PresentationMode = PresentationMode.AMBIENT
@export var lines: Array[DialogueLine] = []
