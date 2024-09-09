extends CharacterBody2D
enum PlayerState {land,water,breached,}

@export  var base_jump_velocity = -10.0
@export var damping_factor = 0.6
@export var trail_offset: Node2D

@onready var jump_arrow: JumpArrow = %JumpArrow

var jumping = false
var current_trail: JumpTrail
var landed = false
@export var player_state: PlayerState = PlayerState.land

func _ready():
  jump_arrow.jump.connect(_on_jump)

func _on_jump(angle: float, power: float):
  match player_state:
    PlayerState.land:
      if is_on_floor():
          var direction = Vector2(cos(angle), sin(angle))
          
          var v_x = direction.x * power * base_jump_velocity
          velocity.x = v_x

          var v_y = direction.y * power * base_jump_velocity
          velocity.y = v_y
          jumping = true
          $frog_hop_audio._play_hop()
          make_trail()
    PlayerState.water:
      pass
    PlayerState.breached:
      pass
        
func _physics_process(delta: float) -> void:
  match player_state:
    PlayerState.land:
      if not is_on_floor():
        landed = false
        jumping = false
        velocity += get_gravity() * delta
      else:
        if not landed:
          $frog_hop_audio._play_landing(false)
          landed = true
      
        velocity.x *= damping_factor
        if abs(velocity.x) < 0.1:
          velocity.x = 0
    PlayerState.water:
      pass
    PlayerState.breached:
      pass
  move_and_slide()
  
func make_trail():
  if current_trail:
    current_trail.stop()
  current_trail = JumpTrail.create()
  add_child(current_trail)
  current_trail.position = trail_offset.position

  
