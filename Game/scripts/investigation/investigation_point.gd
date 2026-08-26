extends Area2D
signal investigated(investigation_id: StringName)
signal scent_detected(
	position: Vector2,
	scent_type: String,
	duration: float,
	colour: Color,
	creates_trail: bool
)

var dog_nearby: bool = false
var dog: Node2D = null
var investigation_count: int = 0
var investigated_this_visit: bool = false

@export var investigations: Array[InvestigationData] = []
@onready var investigation_label: RichTextLabel = $InvestigationText
@export var text_display_duration: float = 5.0
@export var investigation_id: StringName

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("dog"):
		dog = body
		dog.register_interactable(self)
		dog_nearby = true
					
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("dog"):
		dog_nearby = false
		dog.unregister_interactable(self)
		investigated_this_visit = false
		if not investigation_label.visible:
			dog = null

func can_interact() -> bool:
	return dog_nearby and not investigated_this_visit and _has_available_investigation_text()

func get_interaction_text() -> String:
	return "Investigate"
func get_interaction_priority() -> int:
	return 100
	
func interact() -> void:
	_perform_investigation()

func blocks_interaction() -> bool:
	return false
	
func _process(_delta: float) -> void:
	if investigation_label.visible and dog:
		investigation_label.global_position = dog.global_position + Vector2(-60, -130)

func _perform_investigation() -> void:
	if not can_interact():
		return

	for point in get_tree().get_nodes_in_group("investigation_point"):
		point.hide_investigation_text()

	investigated.emit(investigation_id)

	var current_investigation: InvestigationData = investigations[investigation_count]

	investigation_label.text = "[i]%s[/i]" % _get_current_investigation_text()
	investigation_label.global_position = dog.global_position + Vector2(-60, -130)
	investigation_label.show()

	investigation_count += 1
	investigated_this_visit = true
	
	ActState.set_state(investigation_id, {
	"investigation_count": investigation_count
		})

	if current_investigation.has_scent:
		await get_tree().create_timer(1.0).timeout
		scent_detected.emit(
			global_position,
			current_investigation.scent_type,
			current_investigation.scent_duration,
			current_investigation.scent_colour,
			current_investigation.creates_trail
			)

		await get_tree().create_timer(max(text_display_duration - 1.0, 0.0)).timeout
	else:
		await get_tree().create_timer(text_display_duration).timeout

	investigation_label.hide()

	if not dog_nearby:
		dog = null

func hide_investigation_text() -> void:
	investigation_label.hide()
	
func _get_current_investigation_text() -> String:
	return investigations[investigation_count].text

func holds_interaction_priority() -> bool:
	return dog_nearby and investigation_label.visible

func _has_available_investigation_text() -> bool:
	return investigation_count < investigations.size()
	
func _ready() -> void:
	if not ActState.has_state(investigation_id):
		return

	var state: Dictionary = ActState.get_state(investigation_id)
	investigation_count = state.get("investigation_count", 0)
