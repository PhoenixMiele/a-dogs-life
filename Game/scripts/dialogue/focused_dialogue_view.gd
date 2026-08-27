extends Node

@onready var dialogue_bar: ColorRect = $CanvasLayer/FocusedUI/DialogueBar
@onready var dialogue_text: RichTextLabel = $CanvasLayer/FocusedUI/DialogueBar/DialogueText
@export var characters_per_second: float = 35.0
@onready var speaker_name: RichTextLabel = $CanvasLayer/FocusedUI/DialogueBar/SpeakerName
@export var focused_zoom: Vector2 = Vector2(1.1, 1.1)
@export var camera_transition_duration: float = 0.4

var gameplay_camera: Camera2D = null
var original_camera_offset: Vector2 = Vector2.ZERO
var original_camera_zoom: Vector2 = Vector2.ONE
var camera_reframed: bool = false
var conversation: Node = null
var reveal_generation: int = 0

func setup(runtime_conversation: Node) -> void:
	conversation = runtime_conversation
	conversation.line_changed.connect(_on_line_changed)
	conversation.completed.connect(_on_conversation_completed)
	
func _on_line_changed(line: DialogueLine) -> void:
	if (
		conversation.data.presentation_mode
		!= ConversationData.PresentationMode.FOCUSED
	):
		return

	var speaker: Node = conversation.get_current_speaker()

	if speaker == null:
		return

	if not camera_reframed:
		var dog: Node = conversation.participants.get(&"dog")

		if dog and dog.camera:
			gameplay_camera = dog.camera
			original_camera_offset = gameplay_camera.offset
			original_camera_zoom = gameplay_camera.zoom

			var camera_leftmost_x: float = dog.global_position.x
			var camera_rightmost_x: float = dog.global_position.x

			for participant in conversation.participants.values():
				if participant == null:
					continue

				camera_leftmost_x = min(camera_leftmost_x, participant.global_position.x)
				camera_rightmost_x = max(camera_rightmost_x, participant.global_position.x)

			var midpoint_x: float = (
				camera_leftmost_x + camera_rightmost_x
			) / 2.0
			
			var target_offset := gameplay_camera.offset
			target_offset.x = midpoint_x - dog.global_position.x

			var tween := create_tween()
			tween.set_parallel(true)
			tween.tween_property(
				gameplay_camera,
				"offset",
				target_offset,
				camera_transition_duration
			)
			tween.tween_property(
				gameplay_camera,
				"zoom",
				focused_zoom,
				camera_transition_duration
			)

			camera_reframed = true

	var leftmost_x: float = speaker.global_position.x
	var rightmost_x: float = speaker.global_position.x

	for participant in conversation.participants.values():
		if participant == null:
			continue

		leftmost_x = min(leftmost_x, participant.global_position.x)
		rightmost_x = max(rightmost_x, participant.global_position.x)

	var conversation_midpoint: float = (leftmost_x + rightmost_x) / 2.0
	var speaker_is_left: bool = speaker.global_position.x <= conversation_midpoint
	var display_name: String = conversation.get_current_speaker_display_name()

	speaker_name.text = "[b]%s[/b]" % display_name

	if speaker_is_left:
		dialogue_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		speaker_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else:
		dialogue_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		speaker_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	dialogue_bar.visible = true
	speaker_name.visible = true

	reveal_generation += 1
	var generation: int = reveal_generation

	_reveal_line(line.text, speaker_is_left, generation)
	
func _reveal_line(
	text: String,
	from_left: bool,
	generation: int
) -> void:
	for character_count in range(1, text.length() + 1):
		if generation != reveal_generation:
			return

		if from_left:
			dialogue_text.text = text.left(character_count)
		else:
			dialogue_text.text = text.right(character_count)

		await get_tree().create_timer(
			1.0 / characters_per_second
		).timeout
	
func _on_conversation_completed() -> void:
	dialogue_bar.visible = false
	dialogue_text.text = ""
	speaker_name.text = ""
	speaker_name.visible = false
	
	if camera_reframed and gameplay_camera:
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(
			gameplay_camera,
			"offset",
			original_camera_offset,
			camera_transition_duration
		)
		tween.tween_property(
			gameplay_camera,
			"zoom",
			original_camera_zoom,
			camera_transition_duration
		)

	gameplay_camera = null
	camera_reframed = false
