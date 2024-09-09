extends CharacterBody2D

@export  var base_jump_velocity = -10.0
@export var damping_factor = 0.6
@export var trail_offset: Node2D

@onready var jump_arrow: JumpArrow = %JumpArrow

var jumping = false
var current_trail: JumpTrail

func _ready():
  jump_arrow.jump.connect(_on_jump)

func _on_jump(angle: float, power: float):
    if is_on_floor():
        var direction = Vector2(cos(angle), sin(angle))
        
        var v_x = direction.x * power * base_jump_velocity
        velocity.x = v_x

        var v_y = direction.y * power * base_jump_velocity
        velocity.y = v_y
        jumping = true
        make_trail()
        
func _physics_process(delta: float) -> void:
  if not is_on_floor():
    jumping = false
    velocity += get_gravity() * delta
  else:
    velocity.x *= damping_factor
    if abs(velocity.x) < 0.1:
        velocity.x = 0
  move_and_slide()
  
func make_trail():
  if current_trail:
    current_trail.stop()
  current_trail = JumpTrail.create()
  add_child(current_trail)
