extends CanvasLayer

@onready var start_button = $start_button

var level_scene = preload("res://world/level_01.tscn")
var fade_transition = preload("res://ui/scene_transitions/fade_transition.tscn")
var audio_control = AudioControl
var scene_transition = SceneTransitionManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_start_button_pressed() -> void:
  scene_transition.change_scene_with_transition(level_scene, fade_transition)
  audio_control._change_music(audio_control.level_light, 1.5)
