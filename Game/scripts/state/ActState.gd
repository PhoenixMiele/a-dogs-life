extends Node

var _state: Dictionary = {}

func set_state(state_id: StringName, state: Dictionary) -> void:
	_state[state_id] = state

func get_state(state_id: StringName) -> Dictionary:
	return _state.get(state_id, {})

func has_state(state_id: StringName) -> bool:
	return _state.has(state_id)

func clear_act_state() -> void:
	_state.clear()
