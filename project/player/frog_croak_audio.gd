extends AudioStreamPlayer2D

@export var min_interval : float
@export var max_interval : float

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("croak"):
    _croak()

func _croak() -> void:
  play()
