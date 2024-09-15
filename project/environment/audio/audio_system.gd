extends Node

enum audio_bus_type { MASTER, MUSIC, SFX }
enum track_type { TRACK_A, TRACK_B }

@export_range(0.0, 1.0) var master_vol : float
@export_range(0.0, 1.0) var sfx_vol : float
@export_range(0.0, 1.0) var music_vol : float

@export var filter_transition_time : float
@export_range(0.0, 20000) var cutoff : float
@export_range(0.0, 1.0) var resonance : float

# Series of music tracks that can be referenced when changing the music
@export var theme : AudioStreamMP3
@export var level_light : AudioStreamMP3
@export var level_upbeat : AudioStreamMP3

# Audio players
@onready var track_a = $track_A
@onready var track_b = $track_B

var current_track = track_type.TRACK_A

#filter
var lps_filter : AudioEffectFilter

var init_music : bool

# Called when the node enters the scene tree for the first time.
# init bus volumes and effects and play theme music
func _ready() -> void:
  _set_volume(audio_bus_type.MASTER, master_vol)
  _set_volume(audio_bus_type.SFX, sfx_vol)
  _set_volume(audio_bus_type.MUSIC, music_vol)
  
  _init_filter()
  
func _get_volume_normalized(audio_type : audio_bus_type) -> float:
  match(audio_type):
    audio_bus_type.MASTER:
      return db_to_linear(AudioServer.get_bus_volume_db(0))
    audio_bus_type.SFX:
      return db_to_linear(AudioServer.get_bus_volume_db(1))
    audio_bus_type.MUSIC:
      return db_to_linear(AudioServer.get_bus_volume_db(2))
      
  return db_to_linear(AudioServer.get_bus_volume_db(0))
  
func _get_volume(audio_type : audio_bus_type) -> float:
  match(audio_type):
    audio_bus_type.MASTER:
      return AudioServer.get_bus_volume_db(0)
    audio_bus_type.SFX:
      return AudioServer.get_bus_volume_db(1)
    audio_bus_type.MUSIC:
      return AudioServer.get_bus_volume_db(2)
      
  return AudioServer.get_bus_volume_db(0)

func _set_volume(audio_type : audio_bus_type, value : float) -> void:
  match(audio_type):
    audio_bus_type.MASTER:
      master_vol = value
      AudioServer.set_bus_volume_db(0, linear_to_db(value))
    audio_bus_type.SFX:
      sfx_vol = value
      AudioServer.set_bus_volume_db(1, linear_to_db(value))
    audio_bus_type.MUSIC:
      music_vol = value
      AudioServer.set_bus_volume_db(2, linear_to_db(value))
  
# Play starting music - probably the theme
func _init_music(new_track : AudioStreamMP3) -> void:
  track_b.volume_db = -80.0
  track_a.volume_db = 0.0
  track_a.stream = new_track
  track_a.play()
  init_music = true
  
func _init_filter() -> void:
  lps_filter = AudioServer.get_bus_effect(0, 0)
  lps_filter.cutoff_hz = 20500
  lps_filter.resonance = 0.5
  lps_filter.db = AudioEffectFilter.FILTER_24DB
  
func _change_music(new_track : AudioStreamMP3, transition_time : float) -> void:
  var last_track = current_track
  match (current_track):
    track_type.TRACK_A:
      last_track = track_type.TRACK_B
      if (track_b.stream != new_track):
        track_b.stream = new_track
        track_b.play()
        
      #tween other track to stop using transition time and stop playing after transition time
      var tween = get_tree().create_tween()
      tween.tween_property(track_b, ":volume_db", linear_to_db(1.0), transition_time)
      tween.tween_property(track_a, ":volume_db", linear_to_db(0.0001), transition_time)
      
    track_type.TRACK_B:
      last_track = track_type.TRACK_A
      if (track_a.stream != new_track):
        track_a.stream = new_track
        track_a.play()
        
      #tween other track to stop using transition time and stop playing after transition time
      var tween = get_tree().create_tween()
      tween.tween_property(track_a, ":volume_db", linear_to_db(1.0), transition_time)
      tween.tween_property(track_b, ":volume_db", linear_to_db(0.0001), transition_time)
    
  current_track = last_track
  
func _toggle_water_effect(is_under_water : bool) -> void:
  if (is_under_water):
    if (is_instance_valid(get_tree())):
      var tween = get_tree().create_tween()
      tween.tween_property(lps_filter, ":cutoff_hz", cutoff, filter_transition_time)
      tween.tween_property(lps_filter, ":resonance", resonance, filter_transition_time)
  else:
    if (is_instance_valid(get_tree())):
      var tween = get_tree().create_tween()
      tween.tween_property(lps_filter, ":cutoff_hz", 20500, filter_transition_time)
      tween.tween_property(lps_filter, ":resonance", 0.5, filter_transition_time)
      
func _back_to_menu() -> void:
  _change_music(theme, 3.0)
