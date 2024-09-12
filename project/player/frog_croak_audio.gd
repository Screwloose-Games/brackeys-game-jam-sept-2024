extends AudioStreamPlayer2D

@export var min_interval : float
@export var max_interval : float

@export var croak_0 : AudioStreamWAV
@export var croak_1 : AudioStreamWAV
@export var croak_2 : AudioStreamWAV

var croaks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  croaks = [croak_0, croak_1, croak_2]
  #await get_tree().create_timer(randf_range(min_interval, max_interval)).timeout
  #_croak()
  pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventKey:
    if event.keycode == KEY_SPACE:
      if event.pressed:
        _croak()
  pass
  
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _croak() -> void:
  var rand = randi_range(0, 2)
  var pitch = randf_range(0.9, 1.1)
  stream = croaks[rand]
  pitch_scale = pitch
  play()
  #await get_tree().create_timer(randf_range(min_interval, max_interval)).timeout
  #_croak()
  pass
