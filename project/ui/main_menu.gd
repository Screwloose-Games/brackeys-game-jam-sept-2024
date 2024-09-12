extends CanvasLayer

@onready var start_button = $start_button

var level_scene = preload("res://world/level_01.tscn").instantiate()
var audio_control = AudioControl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_start_button_pressed() -> void:
  get_tree().root.add_child(level_scene)
  var main_level = get_tree().current_scene
  get_tree().current_scene = level_scene
  get_tree().root.remove_child(main_level)
  audio_control._change_music(audio_control.level_light, 1.5)
