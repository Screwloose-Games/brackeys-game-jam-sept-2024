extends Node

@export var hover_sound : AudioStreamWAV

@onready var hover = $hover_audio
@onready var confirm = $confirm_audio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  hover.stream = hover_sound

func _hover() -> void:
  hover.play()
  
func _confirm() -> void:
  confirm.play()
