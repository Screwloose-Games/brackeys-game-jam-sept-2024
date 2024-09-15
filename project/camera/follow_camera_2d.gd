class_name FollowCamera2D

extends Camera2D

@export var lerp_speed: float = 5.0  # Speed of the camera's smoothing
@export var offset_y: float = 0.0    # Vertical offset for the camera
@export var min_y: float = -100.0    # Minimum Y position constraint
@export var max_y: float = 100.0     # Maximum Y position constraint

@export var target: Node2D

func _ready():
    if not target:
        target = get_node_or_null("Player")
        if not target:
            print("No target assigned or found.")

func _process(delta: float):
    if target:
        follow_target(delta)

func follow_target(delta: float):
    var current_position = global_position
    var target_position = target.global_position
    var new_y = lerp(current_position.y, target_position.y + offset_y, lerp_speed * delta)
    new_y = clamp(new_y, min_y, max_y)
    global_position.y = new_y
