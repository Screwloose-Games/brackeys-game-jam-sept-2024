class_name Water
extends Node2D

@export var water_rate: float = 1.0
@export var starting_water_height: float = 100
@export var max_water_height: float = 1000
@export var current_water_height: float
@export var water_rise_delay: float = 60
@export var visual_x_offset = 170
var is_rising: bool = false
@onready var water_area: Area2D = $Water
@onready var collision_shape_2d: CollisionShape2D = $Water/CollisionShape2D
@onready var surface_collider = $SurfaceWater
@onready var water_visual_effect = $WaterShader
@onready var water_color = $WaterColor
@onready var surface: CollisionShape2D = $SurfaceWater/Surface


func _ready():
  var water_canvas_group = get_tree().get_first_node_in_group("WaterGroup")
  water_color.reparent(water_canvas_group)
  is_rising = false
  set_collision_shape_and_height(starting_water_height) 
  current_water_height = starting_water_height
  await get_tree().create_timer(water_rise_delay).timeout
  is_rising = true

func _physics_process(delta):
  if is_rising:
    current_water_height = lerp(current_water_height,max_water_height,delta*water_rate)
    set_collision_shape_and_height(current_water_height)

func set_collision_shape_and_height(target_height:float):
  (collision_shape_2d.shape as RectangleShape2D).size.y = target_height
  collision_shape_2d.position.y = target_height/2 * -1
  surface_collider.position.y = (target_height+2.5) * -1
  set_water_visual_effect_size(water_visual_effect,target_height)
  set_water_visual_effect_size(water_color,target_height)

#func _process(delta: float) -> void:
  #set_water_visual_effect_size()

func set_water_visual_effect_size(target_visual,target_height):
    var collision_shape_top = collision_shape_2d.global_position.y - (collision_shape_2d.shape.extents.y) - surface.shape.size.y / 2
    target_visual.size = collision_shape_2d.shape.size
    target_visual.global_position.y = collision_shape_top
    target_visual.global_position.x = collision_shape_2d.global_position.x-visual_x_offset
