extends TextureButton

var CIRCLE_TRANSITION = SceneManager.CIRCLE_TRANSITION
var MAIN_MENU = SceneManager.MAIN_MENU


func _ready() -> void:
  button_up.connect(_on_button_up)

func _on_button_up():
  SceneTransitionManager.change_scene_with_transition(SceneManager.MAIN_MENU, CIRCLE_TRANSITION)
