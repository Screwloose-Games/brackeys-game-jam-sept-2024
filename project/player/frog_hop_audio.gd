extends AudioStreamPlayer2D

@export var hop : AudioStreamWAV
@export var landing : AudioStreamWAV
@export var submerge : AudioStreamWAV
@export var emerge : AudioStreamWAV
@export var swim : AudioStreamWAV

func _play_hop() -> void:
  stream = hop
  volume_db = 0.0
  play()

func _play_landing(is_long_drop: bool) -> void:
  stream = landing
  volume_db = -5.0
  play()

func _play_submerge() -> void:
  stream = submerge
  volume_db = 0.0
  play()

func _play_emerge() -> void:
  stream = emerge
  volume_db = 0.0
  play()
  
func _play_swim() -> void:
  stream = swim
  volume_db = 0.0
  play()
