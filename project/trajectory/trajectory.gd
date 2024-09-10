extends Line2D

@onready var jump_arrow: JumpArrow = %JumpArrow
@export var player: PlayerCharacter
const MAX_POINTS = 50
var gravity: float = 980 # need to get this from engine
var base_jump_velocity = -10.0 # need to get this from player
var water_jump_boost = 1 # need to get this from player
var update_trajectory: bool = false
var show_trajectory: bool = true 
var player_state_breached: bool = true
var trajectory_vel: Vector2 = Vector2.ZERO


func _ready():
  #connect to signals for player and jump arrow
  jump_arrow.jump_preview.connect(_on_update_trajectory)
  jump_arrow.jump.connect(_on_jump_started)
  if player:
    player.breached.connect(_on_player_breached)
    player.exit_breached.connect(_on_player_exit_breach)
    base_jump_velocity = player.base_jump_velocity
    water_jump_boost = player.water_breach_jump_boost
  show_trajectory = false
  update_trajectory = false
  
func _physics_process(delta):
  if show_trajectory:
    visible = true
  else:
    visible = false
  if update_trajectory:
    update_trajectory_preview(delta)

func _on_update_trajectory(angle: float, speed: float):
  var direction = Vector2(cos(angle), sin(angle))
  if player_state_breached:
    show_trajectory = true
    trajectory_vel = direction * speed * base_jump_velocity * water_jump_boost
    update_trajectory = true
  else:
    show_trajectory = false

func _on_jump_started(angle: float, speed: float):
  #once actual jumping starts hide the preview
  update_trajectory = false
  show_trajectory = false

func update_trajectory_preview(delta):
    clear_points()
    var pos: Vector2 = Vector2.ZERO
    for i in MAX_POINTS:
      add_point(pos)
      trajectory_vel.y += gravity * delta
      pos += trajectory_vel * delta
      
func _on_player_breached():
  player_state_breached = true

func _on_player_exit_breach():
  player_state_breached = false
