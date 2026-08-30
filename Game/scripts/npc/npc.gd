extends Node2D
class_name NPC

@onready var ambient_movement: NPCAmbientMovement = $AmbientMovement
@onready var conversation_interactor: Node = $ConversationInteractorTest

func _ready() -> void:
	conversation_interactor.conversation_started.connect(_on_conversation_started)
	conversation_interactor.conversation_completed.connect(_on_conversation_completed)

func _on_conversation_started(conversation_index: int) -> void:
	var conversation_data: ConversationData = (
		conversation_interactor.conversations[conversation_index]
	)

	if conversation_data.presentation_mode == ConversationData.PresentationMode.FOCUSED:
		ambient_movement.set_paused(true)
		
func _on_conversation_completed(_conversation_index: int) -> void:
	ambient_movement.set_paused(false)
