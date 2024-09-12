extends CanvasLayer

@export var finish_area: FinishArea

func _ready() -> void:
  hide()
  finish_area.player_finished.connect(_on_player_finished)

func _on_player_finished():
  show()
