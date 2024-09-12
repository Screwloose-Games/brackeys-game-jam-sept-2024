extends Node

@export var hover_sound : AudioStreamWAV
@export var croak_0 : AudioStreamWAV
@export var croak_1 : AudioStreamWAV
@export var croak_2 : AudioStreamWAV

@onready var hover = $hover_audio
@onready var confirm = $confirm_audio

var croaks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  croaks = [croak_0, croak_1, croak_2]
  hover.stream = hover_sound
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _hover() -> void:
  hover.play()
  pass
  
func _confirm() -> void:
  var rand = randi_range(0, 2)
  var pitch = randf_range(0.9, 1.1)
  confirm.stream = croaks[rand]
  confirm.pitch_scale = pitch
  confirm.play()
  pass
