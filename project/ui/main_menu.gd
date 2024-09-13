extends CanvasLayer

@onready var start_button = $Control/menu_bg/start_button
@onready var options_button = $Control/menu_bg/options_button
@onready var back_options_button = $Control/menu_bg/option_back_button

@onready var master_vol_slider = $Control/menu_bg/master_vol_slider
@onready var master_vol_text = $Control/menu_bg/master_vol_text

@onready var ui_audio = $ui_audio

var level_scene = preload("res://world/level_01.tscn")
var fade_transition = preload("res://ui/scene_transitions/fade_transition.tscn")
var audio_control = AudioControl
var scene_transition = SceneTransitionManager

var is_option_menu_open : bool

func _ready() -> void:
  audio_control._init_music(audio_control.theme)
  master_vol_slider.value = audio_control._get_volume_normalized(audio_control.audio_bus_type.MASTER)
  master_vol_slider.hide()
  master_vol_text.hide()
  back_options_button.hide()

func _on_start_button_pressed() -> void:
  ui_audio._confirm()
  scene_transition.change_scene_with_transition(level_scene, fade_transition)
  audio_control._change_music(audio_control.level_light, 1.5)


func _on_start_button_mouse_entered() -> void:
  ui_audio._hover()

func _on_options_button_pressed() -> void:
    ui_audio._confirm()
    start_button.hide()
    options_button.hide()
    is_option_menu_open = false
    
    master_vol_slider.show()
    master_vol_text.show()
    back_options_button.show()

func _on_options_button_mouse_entered() -> void:
  ui_audio._hover()

func _on_master_vol_slider_mouse_entered() -> void:
  ui_audio._hover()


func _on_master_vol_slider_drag_started() -> void:
  ui_audio._confirm()


func _on_master_vol_slider_value_changed(value: float) -> void:
  audio_control._set_volume(audio_control.audio_bus_type.MASTER, master_vol_slider.value)
  ui_audio._hover()


func _on_option_back_button_mouse_entered() -> void:
  ui_audio._hover()


func _on_option_back_button_pressed() -> void:
  ui_audio._confirm()
  master_vol_slider.hide()
  master_vol_text.hide()
  back_options_button.hide()
  start_button.show()
  options_button.show()
