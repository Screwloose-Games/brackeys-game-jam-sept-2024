extends AudioStreamPlayer2D

@export var min_interval : float
@export var max_interval : float

var croaks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  #await get_tree().create_timer(randf_range(min_interval, max_interval)).timeout
  #_croak()
  pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("croak"):
    _croak()

func _croak() -> void:
  play()
  #await get_tree().create_timer(randf_range(min_interval, max_interval)).timeout
  #_croak()
