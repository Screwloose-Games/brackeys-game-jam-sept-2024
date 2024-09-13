class_name Pool
extends Node2D

@onready var water_pool_color = $WaterPoolColor

func _ready():
  var water_canvas_group = get_tree().get_first_node_in_group("WaterGroup")
  water_pool_color.reparent(water_canvas_group)
