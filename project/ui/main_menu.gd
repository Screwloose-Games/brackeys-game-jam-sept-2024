extends CanvasLayer

@onready var start_button = $start_button
@onready var ui_audio = $ui_audio

var level_scene = preload("res://world/level_01.tscn")
var fade_transition = preload("res://ui/scene_transitions/fade_transition.tscn")
var audio_control = AudioControl
var scene_transition = SceneTransitionManager

func _ready() -> void:
  audio_control._init_music(audio_control.theme)

func _on_start_button_pressed() -> void:
  ui_audio._confirm()
  scene_transition.change_scene_with_transition(level_scene, fade_transition)
  audio_control._change_music(audio_control.level_light, 1.5)


func _on_start_button_mouse_entered() -> void:
  ui_audio._hover()
  pass # Replace with function body.
