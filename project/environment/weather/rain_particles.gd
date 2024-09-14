extends GPUParticles2D

@onready var weather_sfx: Node = $"../../weather_sfx"
@export var follow_target: Node2D
@export var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
  start_light_rain()
  await get_tree().create_timer(5).timeout
  var tween = get_tree().create_tween()
  start_heavy_rain()

# Play rain and wind effects from 0.0 - 1.0 in stength
# calculate the effect of rain intensity and wind intensity on the final rain effect
func start_weather(rain_amount: float, wind_amount: float):
  pass

func start_light_rain():
  var material: ParticleProcessMaterial = process_material
  amount = 400
  material.direction = Vector3(0, 1, 0)
  material.initial_velocity_min = 1200
  material.initial_velocity_max = 2000
  material.angle_min = 0
  material.angle_max = 0
  var text: GradientTexture2D = texture
  text.width = 1
  text.height = 10
  lifetime = 0.4
  weather_sfx._change_rain(false)

func start_rain(amount, direction, vel_min, vel_max, angle_min, angle_max, texture_w, texture_h, lifetime):
  pass

func start_heavy_rain():
  var material: ParticleProcessMaterial = process_material
  amount = 500
  material.direction = Vector3(1.0, 0.5, 0)
  material.initial_velocity_min = 800
  material.initial_velocity_max = 4000
  material.angle_min = 60
  material.angle_max = 60
  var text: GradientTexture2D = texture
  text.width = 2
  text.height = 64
  lifetime = 0.4
  weather_sfx._change_rain(true)

func _process(delta: float) -> void:
  global_position = follow_target.global_position + offset
