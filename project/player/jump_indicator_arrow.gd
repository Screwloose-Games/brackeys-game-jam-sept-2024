class_name JumpArrow
extends Control

signal jump(angle: float, power: float)
signal jump_preview(angle: float, power: float)

@export var max_mouse_dist: float = 20
@export var big_jump: float = 30
@export var small_jump: float = 15
@export var big_arrow: float = 0.5
@export var small_arrow: float = 0.25
@onready var arrow_rotation_pivot: Marker2D = %ArrowRotationPivot
@onready var texture_rect: TextureRect = $TextureRect

var pivot_location: Vector2
var mouse_button_held: bool = false

var pressed_location: Vector2

var mouse_dist: float:
  set(val):
    mouse_dist = min(val, max_mouse_dist)

func _ready() -> void:
    pivot_location = pivot_offset
    visible = false

func get_mobile_origin():
  return pressed_location

func get_direction():
  if OSUtils.is_mobile():
    return get_global_mouse_position() - pressed_location
  else:
    return get_global_mouse_position() - arrow_rotation_pivot.global_position

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                mouse_button_held = true
                visible = true
                pressed_location = get_global_mouse_position()
            else:
                mouse_button_held = false
                visible = false
                #var mouse_pos = get_global_mouse_position()
                var direction = get_direction()
                var angle = direction.angle() + 1.5 * PI
                mouse_dist = direction.length()
                var power = mouse_dist_to_power(mouse_dist)
                rotation = angle
                jump.emit(rotation - 1.5 * PI, power)

func _process(delta: float) -> void:
    if mouse_button_held:
        #var mouse_pos = get_global_mouse_position()
        var direction = get_direction()
        mouse_dist = direction.length()
        var angle = direction.angle() + 1.5 * PI
        var power = mouse_dist_to_power(mouse_dist)
        texture_rect.scale = Vector2(1,1)*mouse_dist_to_arrow_size(mouse_dist)
        rotation = angle
        jump_preview.emit(rotation - 1.5 * PI,power)

func mouse_dist_to_power(dist:float) -> float:
  #set up jump power levels here
  if dist >= max_mouse_dist/2:
    return big_jump
  else:
    return small_jump
    
func mouse_dist_to_arrow_size(dist:float) -> float:
  if dist >= max_mouse_dist/2:
    return big_arrow
  else:
    return small_arrow
