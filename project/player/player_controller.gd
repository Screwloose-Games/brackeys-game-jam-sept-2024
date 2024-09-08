extends CharacterBody2D

@export  var base_jump_velocity = -10.0

@onready var jump_arrow: JumpArrow = %JumpArrow

var jumping = false

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
        
func _physics_process(delta: float) -> void:
  if not is_on_floor():
    jumping = false
    velocity += get_gravity() * delta
  else:
    if not jumping:
      velocity = Vector2.ZERO
  move_and_slide()
