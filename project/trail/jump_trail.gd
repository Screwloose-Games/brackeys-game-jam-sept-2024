class_name JumpTrail
extends Line2D

const MAX_POINTS: int = 20
#@onready var queue : Array
@onready var curve := Curve2D.new()
@export var color_start: Color
@export var color_end: Color
@export var line_width: int

func _ready():
  gradient.set_color(0,color_start)
  gradient.set_color(1,color_end)
  width = line_width
  clear_points()

func _process(delta: float) -> void:
  curve.add_point(get_parent().position)
  if curve.get_baked_points().size() > MAX_POINTS:
    curve.remove_point(0)
  points = curve.get_baked_points()

func stop() -> void:
  set_process(false)
  await remove_points()
  clear_points()
  queue_free()
  
static func create() -> JumpTrail:
  var jump_trail_scn = preload("res://trail/jump_trail.tscn")
  return jump_trail_scn.instantiate()

func remove_points():
  for point in curve.get_baked_points():
    curve.remove_point(0)
