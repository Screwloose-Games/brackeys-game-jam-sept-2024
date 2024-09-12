extends Node

@onready var hover = $hover_audio
@onready var confirm = $confirm_audio

func _hover() -> void:
  hover.play()
  
func _confirm() -> void:
  confirm.play()
