extends Line2D

@onready var jump_arrow: JumpArrow = %JumpArrow
const MAX_POINTS = 200
var gravity: float = 980
var update_trajectory: bool = false
var show_trajectory: bool = true 
var trajectory_vel: Vector2 = Vector2.ZERO
#need to find a way to dynamically set gravity

func _ready():
  jump_arrow.jump_preview.connect(_on_update_trajectory)
  jump_arrow.jump.connect(_on_jump_started)
  
func _on_update_trajectory(dir: Vector2, speed: float):
  trajectory_vel = dir * speed
  update_trajectory = true
  #later on we can make the show conditional on player state
  show_trajectory = true

func _on_jump_started():
  update_trajectory = false
  show_trajectory = false

func _physics_process(delta):
  if update_trajectory:
    update_trajectory_preview(delta)

func update_trajectory_preview(delta):
    clear_points()
    var pos: Vector2 = Vector2.ZERO
    for i in MAX_POINTS:
      add_point(pos)
      trajectory_vel.y += gravity * delta
      pos += trajectory_vel * delta
