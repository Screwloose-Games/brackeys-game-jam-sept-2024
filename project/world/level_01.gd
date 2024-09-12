extends Node2D

var audio_control = AudioControl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  if (not audio_control.init_music):
    audio_control._init_music(audio_control.level_light)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
