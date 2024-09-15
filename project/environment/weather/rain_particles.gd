class_name WeatherController

extends GPUParticles2D

@export var follow_target: Node2D
@export var offset: Vector2 = Vector2.ZERO
@export_range(0.0, 1.0) var rain: float = 0.0:
  set(val):
    rain = float(val)
    start_weather(rain, wind)
    weather_updated.emit(rain, wind)
    
@export_range(-1.0, 1.0) var wind: float = 0.0:
  set(val):
    wind = float(val)
    start_weather(rain, wind)
    weather_updated.emit(rain, wind)

signal weather_updated(rain: float, wind: float)

func set_weather(init_rain: float, init_wind: float):
  rain = init_rain
  wind = init_wind

var weather_condition: WeatherCondition = WeatherCondition.GENTLE

enum WeatherCondition {
  HEAVY_LEFT,
  HEAVY_RIGHT,
  GENTLE,
  WARNING_LEFT,
  WARNING_RIGHT
}

# Heavy rain start
# wind start left. 10 sec.

# 10 sec heavy rain
# 10 sec wind

# reduce rain (die down)
# reduce wind 

# mild rain, wind (0.25, 0.25)
# 5 sec heavy wind, rain LEFT (1.0, -1.0)
# Heavy rain start
# wind start left. 10 sec.
# Calm for 45 sec (0, 0)
# tween to mild over 5 seconds (0.25, 0.25)
# wait 10 seconds
# tween to strong over 3 seconds ()
# 5 sec strong LEFT (1.0, -1.0)

@onready var weather_sfx: Node = %weather_sfx

func start_weather(rain_amount: float, wind_amount: float):
    #var rain_intensity = lerp(200, 600, rain_amount)
    var rain_intensity = 600
    var rain_velocity_min = lerp(1200, 800, rain_amount)
    var rain_velocity_max = lerp(2000, 4000, rain_amount)
    var rain_direction_x = lerpf(-1, 1, (wind_amount + 1) * 0.5)
    var rain_direction_y = lerpf(0.5, 1, abs(wind_amount))
    var rain_direction = Vector3(rain_direction_x, rain_direction_y, 0)
    var rain_angle_min = lerpf(-60, 60, (wind_amount + 1) * 0.5)
    var rain_angle_max = rain_angle_min
    var texture_width = lerp(1, 2, rain_amount)
    var texture_height = lerp(10, 64, rain_amount)
    var rain_lifetime = 0.4 

    start_rain(
        rain_intensity, 
        rain_direction, 
        rain_velocity_min, 
        rain_velocity_max, 
        rain_angle_min, 
        rain_angle_max, 
        texture_width, 
        texture_height, 
        rain_lifetime
    )
    if weather_sfx:
      weather_sfx._adjust_rain(rain_amount, wind_amount)

func start_rain(init_amount: int, direction, vel_min, vel_max, angle_min, angle_max, texture_w, texture_h, p_lifetime):
    var material: ParticleProcessMaterial = process_material
    amount = init_amount
    material.direction = direction
    material.initial_velocity_min = vel_min
    material.initial_velocity_max = vel_max
    material.angle_min = angle_min
    material.angle_max = angle_max

    var text: GradientTexture2D = texture
    text.width = texture_w
    text.height = texture_h

    lifetime = p_lifetime

func _process(delta: float) -> void:
  global_position = follow_target.global_position + offset
