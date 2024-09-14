extends Control

var player_name

@onready var button = %Button

@onready var margin_container = $"../.."
@onready var animation_player = $AnimationPlayer
@onready var line_edit: LineEdit = $Node2D/LineEdit
@onready var score_value = $Node2D/HBoxContainer/ScoreValue

var LEADERBOARD = SceneManager.LEADERBOARD
var CIRCLE_TRANSITION = SceneManager.CIRCLE_TRANSITION
var score: int

func _ready():
    score_value.text = TimeUtils.convert_ms_to_time(score)
    #line_edit.focus_entered.connect(_on_input_field_focussed)
    Popup1()
    line_edit.grab_focus()

func _on_input_field_focussed():
    if OSUtils.supports_touch():
        line_edit.text ="Your Name"
    var input_text = line_edit.text
    OSUtils.handle_text_input_text_focus(input_text)

func _on_button_pressed():
    var inputtext = line_edit.text
    if inputtext == "":
        line_edit.grab_focus()
        return
    player_name = inputtext
    await SilentWolf.Scores.save_score(player_name, score)
    #margin_container.visible = false
    SceneTransitionManager.change_scene_with_transition(LEADERBOARD, CIRCLE_TRANSITION)
    queue_free()

func Popup1():
    animation_player.play("Popup")

func _input(event):
    if event.is_action_released("ui_accept"):
        _on_button_pressed()
