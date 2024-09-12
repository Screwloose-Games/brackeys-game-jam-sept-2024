extends AudioStreamPlayer2D

@export var min_interval : float
@export var max_interval : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  _play_drip()

func _play_drip() -> void:
  play()
  await get_tree().create_timer(randf_range(min_interval, max_interval)).timeout
  _play_drip()
