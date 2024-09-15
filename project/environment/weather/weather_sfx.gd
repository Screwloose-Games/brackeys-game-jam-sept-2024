extends Node

@onready var light_rain = $light_rain_player
@onready var heavy_rain = $heavy_rain_player
@onready var wind = $wind_player

@export var light_rain_vol = -15.0
@export var heavy_rain_vol = -15.0
@export var wind_vol = -10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  light_rain_vol = db_to_linear(light_rain_vol)
  heavy_rain_vol = db_to_linear(heavy_rain_vol)
  wind_vol = db_to_linear(wind_vol)
  _play_rain()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _play_rain() -> void:
  if (light_rain.stream):
    light_rain.volume_db = linear_to_db(0.0)
    #light_rain.volume_db = linear_to_db(light_rain_vol)
    light_rain.play()
    
  if (heavy_rain.stream):
    heavy_rain.volume_db = linear_to_db(0.0)
    heavy_rain.play()
    
  if (wind.stream):
    wind.volume_db = linear_to_db(0.0)
    wind.play()
  
func _adjust_rain(rain_amount: float, wind_amount: float) -> void:
  light_rain.volume_db = linear_to_db(max(light_rain_vol * 1.0 - rain_amount, 0.0))
  heavy_rain.volume_db = linear_to_db(max(heavy_rain_vol * rain_amount, 0.0))
  wind.volume_db = linear_to_db(max(wind_vol * abs(wind_amount), 0.0))
