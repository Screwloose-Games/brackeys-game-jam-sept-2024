class_name Water
extends Node2D

@export var water_rate: float = 1.0
@export var starting_water_height: float = 100
@export var max_water_height: float = 1000
@export var current_water_height: float
@onready var collision_shape_2d = $Water/CollisionShape2D
@onready var surface_collider = $SurfaceWater

func _ready():
  set_collision_shape_and_height(starting_water_height) 
  current_water_height = starting_water_height

func _physics_process(delta):
  current_water_height = lerp(current_water_height,max_water_height,delta*water_rate)
  set_collision_shape_and_height(current_water_height)

func set_collision_shape_and_height(target_height:float):
  (collision_shape_2d.shape as RectangleShape2D).size.y = target_height
  collision_shape_2d.position.y = target_height/2 * -1  
  surface_collider.position.y = (target_height+2.5) * -1  
