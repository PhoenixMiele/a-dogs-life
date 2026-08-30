extends Area2D

signal conversation_started(conversation_index: int)
signal conversation_completed(conversation_index: int)

@export var conversation_id: StringName
@export var conversations: Array[ConversationData] = []
@onready var conversation: Node = $Conversation
@export var participant_node: Node
@onready var ambient_driver: Node = $AmbientConversationDriver
@onready var focused_driver: Node = $FocusedConversationDriver
@onready var ambient_view: Node = $AmbientDialogueView
@onready var focused_view: Node = $FocusedDialogueView
@export var participant_display_names: Dictionary[StringName, String] = {}

var current_conversation_index: int = 0
var dog: Node = null

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("dog"):
		return

	dog = body
	dog.register_interactable(self)

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("dog"):
		return

	dog.unregister_interactable(self)
	dog = null
	
func can_interact() -> bool:
	return dog != null and can_start_conversation()

func get_interaction_text() -> String:
	return "Talk"

func get_interaction_priority() -> int:
	return 75

func blocks_interaction() -> bool:
	return true

func holds_interaction_priority() -> bool:
	return false
	
func interact() -> void:
	start_next_conversation()

func start_next_conversation() -> void:
	if not can_start_conversation():
		return

	if dog == null:
		dog = get_tree().get_first_node_in_group("dog")

	if dog == null:
		return

	var conversation_data: ConversationData = conversations[current_conversation_index]
	
	conversation_started.emit(current_conversation_index)
	
	conversation.start(
		conversation_data,
		{
			&"dog": dog,
			&"npc": participant_node
		},
		participant_display_names
	)

func can_start_conversation() -> bool:
	return (
		not conversation.active
		and current_conversation_index < conversations.size()
	)

func _ready() -> void:
	conversation.completed.connect(_on_conversation_completed)
	ambient_driver.setup(conversation)
	focused_driver.setup(conversation)
	
	ambient_view.setup(conversation)
	focused_view.setup(conversation)

	if ActState.has_state(conversation_id):
		var state: Dictionary = ActState.get_state(conversation_id)
		current_conversation_index = state.get("current_conversation_index", 0)

func _on_conversation_completed() -> void:
	var completed_index: int = current_conversation_index
	current_conversation_index += 1

	ActState.set_state(conversation_id, {
		"current_conversation_index": current_conversation_index
	})

	conversation_completed.emit(completed_index)
