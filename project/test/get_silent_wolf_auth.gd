class_name SilentWolfAuth
extends RefCounted

static var data = {}
static var config = ConfigFile.new()
static var section_name = "silent_wolf"

static var err = config.load("res://silent_wolf.cfg")

static func get_data():
  var api_key = config.get_value(section_name, "API_KEY")
  var game_id = config.get_value(section_name, "GAME_ID")
  return {"api_key": api_key, "game_id": game_id, "log_level": 1}
