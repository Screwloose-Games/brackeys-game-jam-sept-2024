class_name Pool
extends Node2D

@onready var surface_water = $SurfaceWater
@onready var water_pool_color = $WaterPoolColor
@onready var water_ref: Node2D = %Water
var pool_height: float

func _ready():
  pool_height = position.y+surface_water.position.y-4
  var water_canvas_group = get_tree().get_first_node_in_group("WaterGroup")
  water_pool_color.reparent(water_canvas_group)
  
func _physics_process(delta):
  if -water_ref.current_water_height <= pool_height:
    print("pool removed")
    queue_free()
