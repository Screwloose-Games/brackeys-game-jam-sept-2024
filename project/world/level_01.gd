extends Node2D

var audio_control = AudioControl
var reached_mid_level : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  if (not audio_control.init_music):
    audio_control._init_music(audio_control.level_light)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if (not reached_mid_level && $PlayerController.position.y < -1150):
    audio_control._change_music(audio_control.level_upbeat, 1.5)
    reached_mid_level = true
