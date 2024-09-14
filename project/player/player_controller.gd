class_name PlayerCharacter
extends CharacterBody2D
enum PlayerState {land,water,breached,}
signal breached()
signal exit_breached()
signal landed()
signal state_changed(new_state: PlayerState)

@export var base_jump_velocity = -10.0
@export var damping_factor = 0.6
@export var water_damping_factor = 0.8
@export var breach_position_surface_offset = 3 
@export var water_breach_jump_boost = 2
@export var trail_offset: Node2D
@export var apex_velocity_max: float = 1.0
@export var current_pool_height: float = 0

@onready var jump_arrow: JumpArrow = %JumpArrow
@onready var water_ref: Node2D = %Water

@onready var audio_control = AudioControl

var jumping = false
var current_trail: JumpTrail
var _is_on_floor = false
var jump_from_breach: bool = false
var water_layer: int = 4
var breach_layer: int = 8
var pool_layer: int = 32
var pool_breach_layer: int = 16
var just_jumped = false
var in_pool: bool = false
var in_water: bool = false
@export var player_state: PlayerState = PlayerState.land:
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
        var chance = randi_range(0, 100)
        if (chance > 70):
          $frog_croak_audio._croak()
          
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
      var chance = randi_range(0, 100)
      if (chance > 70):
        $frog_croak_audio._croak()
        
      var direction = Vector2(cos(angle), sin(angle))
      
      var v_x = direction.x * power * base_jump_velocity
      velocity.x = v_x

      var v_y = direction.y * power * base_jump_velocity
      velocity.y = v_y
      jumping = true
      #play swim sound here
      $frog_hop_audio._play_swim()
      
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
      if not jump_from_breach and not in_pool:
        position = Vector2(position.x,-water_ref.current_water_height-breach_position_surface_offset)
      elif not jump_from_breach and in_pool:
        position= Vector2(position.x,current_pool_height)
  move_and_slide()
  
func make_trail():
  if current_trail:
    current_trail.stop()
    
  current_trail = JumpTrail.create()
  add_child(current_trail)
  current_trail.position = trail_offset.position

func _on_water_detector_area_entered(area:Area2D):
  if area.collision_layer == water_layer:
    in_water = true
  if player_state == PlayerState.water:
    if area.collision_layer == breach_layer or area.collision_layer == pool_breach_layer:
      if in_pool:
        #edge case
        pass
      else:
        print("water detector enter trigger breach")
        player_state = PlayerState.breached
        breached.emit()
        velocity = Vector2.ZERO
        $frog_hop_audio._play_emerge()
        audio_control._toggle_water_effect(false)
  if player_state == PlayerState.land or PlayerState.breached:
    if area.collision_layer == water_layer or area.collision_layer==pool_layer:
      if (area.owner is Pool):
        current_pool_height = (area.owner as Pool).pool_height
        in_pool = true
      else:
        #edge case
        pass
      print("water detector enter ", in_pool)
      $frog_hop_audio._play_submerge()
      audio_control._toggle_water_effect(true)
      jump_from_breach = false
      exit_breached.emit()
      player_state = PlayerState.water
      
func _on_water_detector_area_exited(area):
  if area.collision_layer == water_layer:
    in_water = false
  if player_state == PlayerState.breached:
    if area.collision_layer == breach_layer or area.collision_layer == pool_breach_layer:
      in_pool = false
      print("exited breach colliding with", area)
      player_state = PlayerState.land
      exit_breached.emit()
      jump_from_breach = false
      audio_control._toggle_water_effect(false)
  if player_state == PlayerState.water:
    if area.collision_layer == water_layer or area.collision_layer == pool_layer:
      if (area.owner is Pool):
        current_pool_height = (area.owner as Pool).pool_height
        in_pool = true
        print("in pool is true!")
      else:
        in_pool = false
      if not in_water:
        print("water detector exit trigger breach",area, in_pool)
        player_state = PlayerState.breached
        velocity = Vector2.ZERO
        breached.emit()
        audio_control._toggle_water_effect(false)
      else:
        #edge case:
        #if exiting a water/pool layer, while still in_water pool despawned
        pass

func just_jumped_delay():
  await get_tree().create_timer(0.1).timeout
  just_jumped = false
  if is_on_floor():
    landed.emit()
    

  
