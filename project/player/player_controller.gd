class_name PlayerCharacter
extends CharacterBody2D
enum PlayerState {land,water,breached,}
signal breached()
signal exit_breached()
signal landed()
signal state_changed(new_state: PlayerState)

@export  var base_jump_velocity = -10.0
@export var damping_factor = 0.6
@export var water_damping_factor = 0.8
@export var breach_position_surface_offset = 3 
@export var water_breach_jump_boost = 2
@export var trail_offset: Node2D

@onready var jump_arrow: JumpArrow = %JumpArrow
@onready var water_ref: Node2D = %Water

var jumping = false
var current_trail: JumpTrail
var _is_on_floor = false
var jump_from_breach: bool = false
var water_layer: int = 4
var breach_layer: int = 8
var just_jumped = false
@export var player_state: PlayerState = PlayerState.water:
  set(val):
    if val != player_state:
      state_changed.emit(val)
    player_state = val


func _ready():
  jump_arrow.jump.connect(_on_jump)
  make_trail()

func _on_jump(angle: float, power: float):
  match player_state:
    PlayerState.land:
      if is_on_floor():
        just_jumped = true
        just_jumped_delay()
        var direction = Vector2(cos(angle), sin(angle))
        
        var v_x = direction.x * power * base_jump_velocity
        velocity.x = v_x

        var v_y = direction.y * power * base_jump_velocity
        velocity.y = v_y
        jumping = true
        $frog_hop_audio._play_hop()
    PlayerState.water:
      var direction = Vector2(cos(angle), sin(angle))
      
      var v_x = direction.x * power * base_jump_velocity
      velocity.x = v_x

      var v_y = direction.y * power * base_jump_velocity
      velocity.y = v_y
      jumping = true
      #play swim sound here
      $frog_hop_audio._play_hop()
      
    PlayerState.breached:
      jump_from_breach = true
      var direction = Vector2(cos(angle), sin(angle))
      
      var v_x = direction.x * power * base_jump_velocity * water_breach_jump_boost
      velocity.x = v_x

      var v_y = direction.y * power * base_jump_velocity * water_breach_jump_boost
      velocity.y = v_y
      jumping = true
      
        
func _physics_process(delta: float) -> void:
  match player_state:
    PlayerState.land:
      if not is_on_floor():
        _is_on_floor = false
        jumping = false
        velocity += get_gravity() * delta
      else:
        if not _is_on_floor:
          $frog_hop_audio._play_landing(false)
          _is_on_floor = true
          landed.emit()
        if not just_jumped:
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
      velocity.x *= water_damping_factor
      if not jump_from_breach:
        position = Vector2(position.x,-water_ref.current_water_height-breach_position_surface_offset)
  move_and_slide()
  
func make_trail():
  if current_trail:
    current_trail.stop()
  current_trail = JumpTrail.create()
  add_child(current_trail)
  current_trail.position = trail_offset.position

  


func _on_water_detector_area_entered(area:Area2D):
  if player_state == PlayerState.water:
    if area.collision_layer == breach_layer:
      player_state = PlayerState.breached
      breached.emit()
      velocity = Vector2.ZERO
      #print("entering breached - play breaching water sound here")
  if player_state == PlayerState.land or PlayerState.breached:
    if area.collision_layer == water_layer:
      #print("entered water - play landing in water sound")
      jump_from_breach = false
      exit_breached.emit()
      player_state = PlayerState.water
  
func _on_water_detector_area_exited(area):
  if player_state == PlayerState.breached:
    if area.collision_layer == breach_layer:
      player_state = PlayerState.land
      exit_breached.emit()
      jump_from_breach = false
      #print("on land - play jumping out of water sound")
  if player_state == PlayerState.water:
    if area.collision_layer == water_layer:
      player_state = PlayerState.breached
      velocity = Vector2.ZERO
      breached.emit()
      #print("entering breached - play breaching water sound here")

func just_jumped_delay():
  await get_tree().create_timer(0.1).timeout
  just_jumped = false
  
