extends GPUParticles2D

@onready var weather_sfx: Node = $"../../weather_sfx"
@export var follow_target: Node2D
@export var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
  start_light_rain()
  await get_tree().create_timer(5).timeout
  var tween = get_tree().create_tween()
  start_heavy_rain()

func start_light_rain():
  var material: ParticleProcessMaterial = process_material
  amount = 200
  material.direction = Vector3(0, 1, 0)
  material.initial_velocity_min = 800
  material.initial_velocity_max = 1000
  var text: GradientTexture2D = texture
  text.width = 1
  lifetime = 0.4
  trail_lifetime = 0.06
  weather_sfx._change_rain(false)

func start_heavy_rain():
  var material: ParticleProcessMaterial = process_material
  amount = 500
  material.direction = Vector3(1.0, 0.5, 0)
  material.initial_velocity_min = 800
  material.initial_velocity_max = 4000
  var text: GradientTexture2D = texture
  text.width = 2
  lifetime = 0.4
  trail_lifetime = 0.06
  weather_sfx._change_rain(true)

func _process(delta: float) -> void:
  global_position = follow_target.global_position + offset
