extends AudioStreamPlayer2D

@export var hop : AudioStreamWAV
@export var landing : AudioStreamWAV
@export var submerge : AudioStreamWAV
@export var emerge : AudioStreamWAV
@export var swim : AudioStreamWAV

@onready var frog_water_hop_audio = $frog_water_hop_audio

func _play_hop() -> void:
  stream = hop
  volume_db = 2.0
  play()

func _play_landing(is_long_drop: bool) -> void:
  stream = landing
  volume_db = -5.0
  play()

func _play_submerge() -> void:
  frog_water_hop_audio.stream = submerge
  frog_water_hop_audio.volume_db = -1.0
  frog_water_hop_audio.play()

func _play_emerge() -> void:
  frog_water_hop_audio.stream = emerge
  frog_water_hop_audio.volume_db = -1.0
  frog_water_hop_audio.play()
  
func _play_swim() -> void:
  frog_water_hop_audio.stream = swim
  frog_water_hop_audio.volume_db = -1.0
  frog_water_hop_audio.play()
