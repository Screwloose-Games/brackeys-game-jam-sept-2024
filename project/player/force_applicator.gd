class_name ForceApplicator

extends Node

@export var force_scale: float = 1.0
@export var wind_force_scale: float = 500.0
@export_range(-1.0, 1.0) var wind_force_direction: float = 0.0

var forces: Dictionary = {}
var wind_force: float:
  get: return wind_force_scale * wind_force_direction

func _ready() -> void:
  var weather_controller: WeatherController = get_tree().get_first_node_in_group("WeatherController")
  weather_controller.weather_updated.connect(_on_weather_updated)

func apply_wind_force(wind: float):
  wind_force_direction = wind
  add_force("wind", Vector2(wind_force, 0))

func _on_weather_updated(_rain: float, wind: float):
  apply_wind_force(wind)

func add_force(key: String, val: Vector2):
  forces[key] = val

func remove_force(key: String, val: Vector2):
  forces.erase(key)

func get_all() -> Array:
  return (forces.values() as Array[Vector2])\
  .map(func(val: Vector2): return val * force_scale)

func get_aggregate() -> Vector2:
  return get_all()\
  .reduce(func(accum: Vector2, num: Vector2): return accum + num, Vector2.ZERO)
