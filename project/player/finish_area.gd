class_name FinishArea
extends Area2D

signal player_finished

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    player_finished.emit()
