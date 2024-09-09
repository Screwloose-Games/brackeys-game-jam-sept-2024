extends AudioStreamPlayer2D

@export var hop_sound : AudioStreamWAV
@export var landing_sound : AudioStreamWAV

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
  
func _play_hop() -> void:
  stream = hop_sound
  play()
  pass

func _play_landing(is_long_drop: bool) -> void:
  stream = landing_sound
  play()
  pass
