extends CharacterBody2D
enum PlayerState {land,water,breached,}

@export  var base_jump_velocity = -10.0
@export var damping_factor = 0.6
@export var water_damping_factor = 0.8
@export var breach_threshold = 5 
@export var water_breach_jump_boost = 1.1
@export var trail_offset: Node2D

@onready var jump_arrow: JumpArrow = %JumpArrow
@onready var water_ref: Node2D = %Water

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
      var direction = Vector2(cos(angle), sin(angle))
      
      var v_x = direction.x * power * base_jump_velocity
      velocity.x = v_x

      var v_y = direction.y * power * base_jump_velocity
      velocity.y = v_y
      jumping = true
      $frog_hop_audio._play_hop()
      
    PlayerState.breached:
      var direction = Vector2(cos(angle), sin(angle))
      
      var v_x = direction.x * power * base_jump_velocity * water_breach_jump_boost
      velocity.x = v_x

      var v_y = direction.y * power * base_jump_velocity * water_breach_jump_boost
      velocity.y = v_y
      jumping = true
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
      velocity *= water_damping_factor 
      if abs(velocity.x) < 0.1:
        velocity.x = 0
      if abs(velocity.y) < 0.1:
        velocity.y = 0
        
    PlayerState.breached:
      var new_pos = position.move_toward(Vector2(position.x,water_ref.current_water_height),5)
      position = new_pos
  move_and_slide()
  
func make_trail():
  if current_trail:
    current_trail.stop()
  current_trail = JumpTrail.create()
  add_child(current_trail)
  current_trail.position = trail_offset.position

  


func _on_water_detector_area_entered(area:Area2D):
  if player_state == PlayerState.water:
    if area.collision_layer == 8:
      player_state = PlayerState.breached
  if player_state == PlayerState.land or PlayerState.breached:
    if area.collision_layer == 4:
      player_state = PlayerState.water
  
  

func _on_water_detector_area_exited(area):
  if player_state == PlayerState.breached:
    if area.collision_layer == 8:
      player_state = PlayerState.land
    
  player_state = PlayerState.land
