extends AudioStreamPlayer2D

@export var hop : AudioStreamWAV
@export var landing : AudioStreamWAV
@export var submerge : AudioStreamWAV
@export var emerge : AudioStreamWAV
@export var swim : AudioStreamWAV

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
  
func _play_hop() -> void:
  stream = hop
  volume_db = 0.0
  play()
  pass

func _play_landing(is_long_drop: bool) -> void:
  stream = landing
  volume_db = -5.0
  play()
  pass

func _play_submerge() -> void:
  stream = submerge
  volume_db = 0.0
  play()
  pass

func _play_emerge() -> void:
  stream = emerge
  volume_db = 0.0
  play()
  pass
  
func _play_swim() -> void:
  stream = swim
  volume_db = 0.0
  play()
  pass
