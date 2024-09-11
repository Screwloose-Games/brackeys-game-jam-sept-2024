extends Node

@export var play_heavy_rain : bool
@export_range(0.0, 1.0) var transition_speed : float
@onready var light_rain = $light_rain_player
@onready var heavy_rain = $heavy_rain_player

var min_volume = -80.0
var max_volume = -10.0
@export var transition = 0.0
var start_transition : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  _play_rain()
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if (start_transition):
    light_rain.volume_db = linear_to_db(lerp(1.0, 0.0, transition))
    heavy_rain.volume_db = linear_to_db(lerp(0.0, 1.0, transition))
      
    if (play_heavy_rain):      
      if (transition < 1.0):
        transition += delta * transition_speed
      else:
        start_transition = false
        
    else:
      if (transition > 0.0):
        transition -= delta * transition_speed
      else:
        start_transition = false
  pass

func _play_rain() -> void:
  if (light_rain.stream):
    light_rain.volume_db = linear_to_db(1.0)
    light_rain.play()
    
  if (heavy_rain.stream):
    heavy_rain.volume_db = linear_to_db(0.0)
    heavy_rain.play()
    
  start_transition = false
  transition = 0.0
  pass
  
func _change_rain(is_heavy: bool) -> void:
  if (is_heavy != play_heavy_rain):
    play_heavy_rain = is_heavy
    start_transition = true
  pass
