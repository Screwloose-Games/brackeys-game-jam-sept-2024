extends AnimatedSprite2D

@export var max_swim_poised_velocity: float = 28.0
@onready var player_controller: PlayerCharacter = owner
@onready var jump_arrow: JumpArrow = %JumpArrow
@onready var ground_detector: RayCast2D = %GroundDetector


func _ready() -> void:
  jump_arrow.jump.connect(_on_jump)
  player_controller.landed.connect(_on_landed)
  player_controller.breached.connect(_on_breeched)
  player_controller.state_changed.connect(_on_player_state_changed)

func _on_ground_body_entered(body: PhysicsBody2D):
  pass

func _on_player_state_changed(new_state: PlayerCharacter.PlayerState):
  match new_state:
    PlayerCharacter.PlayerState.water:
      stop()
      if player_controller.velocity.length() > max_swim_poised_velocity:
        play("swim_released")
      else:
        play("swim_poised")

func _on_breeched():
  breeched()

func breeched():
  stop()
  play("floating")

func _on_jump(angle: float, power: float):
  match player_controller.player_state:
    PlayerCharacter.PlayerState.water:
      play("swim_released")
      stop()
      return
  jump()

func _on_landed():
  land()

func jump():
  stop()
  play("jump_start")
  await animation_finished
  play("jump_rising")

func land():
  stop()
  play("jump_landing")
  await animation_finished
  play("idle")

func _physics_process(delta: float) -> void:
  if player_controller.player_state == player_controller.PlayerState.land:
    if ground_detector.is_colliding() and player_controller.velocity.y >= 0 and not player_controller.is_on_floor():
      land()
    elif abs(player_controller.velocity.y) < 8 and not player_controller.is_on_floor() and animation != "jump_apex":
      play("jump_apex")
      await get_tree().create_timer(0).timeout
      play("jump_falling")
      stop()
  elif player_controller.player_state == player_controller.PlayerState.water and player_controller.velocity.length() < max_swim_poised_velocity and animation != "swim_poised":
    stop()
    play("swim_poised")
