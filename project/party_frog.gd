extends Node2D
enum DanceType {LittleHop,BigHopSide,Croak,HeadBob,HopUp,HopDown}
@export var finish_area: FinishArea
@export var frog_type: DanceType = DanceType.LittleHop
@export var dance: bool = false
@onready var animation_player = $AnimationPlayer
@export var dance_sequence: Array[DanceType]

func _ready():
  dance = false
  if finish_area != null:
    finish_area.player_finished.connect(_on_player_finished)
  else:
    print("finish area null")

func _on_player_finished():
  dance = true
  pass

func _physics_process(delta):
  if dance:
    if dance_sequence.size()>0:
      for elelment in dance_sequence:
        match elelment:
          DanceType.LittleHop:
            animation_player.queue("small_hop")
          DanceType.HeadBob:
            animation_player.queue("head_bob")
          DanceType.BigHopSide:
            animation_player.queue("big_hop_side")
          DanceType.Croak:
            animation_player.queue("frog_croak")
          DanceType.HopUp:
            animation_player.queue("hop_up")
          DanceType.HopDown:
            animation_player.queue("hop_down")
    else:
      match frog_type:
        DanceType.LittleHop:
          animation_player.queue("small_hop")
        DanceType.HeadBob:
          animation_player.queue("head_bob")
        DanceType.BigHopSide:
          animation_player.queue("big_hop_side")
        DanceType.Croak:
          animation_player.queue("frog_croak")
        DanceType.HopUp:
          animation_player.queue("hop_up")
        DanceType.HopDown:
          animation_player.queue("hop_down")
        
      
