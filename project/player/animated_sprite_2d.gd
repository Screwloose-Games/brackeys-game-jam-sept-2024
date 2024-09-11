extends AnimatedSprite2D

@onready var player_controller: PlayerCharacter = owner
@onready var jump_arrow: JumpArrow = %JumpArrow


func _ready() -> void:
  jump_arrow.jump.connect(_on_jump)
  player_controller.landed.connect(_on_landed)
  player_controller.breached.connect(_on_breeched)
  player_controller.state_changed.connect(_on_player_state_changed)

func _on_player_state_changed(new_state: PlayerCharacter.PlayerState):
  match new_state:
    PlayerCharacter.PlayerState.water:
      play("swim_poised")

func _on_breeched():
  breeched()

func breeched():
  stop()
  play("floating")

func _on_jump(angle: float, power: float):
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
