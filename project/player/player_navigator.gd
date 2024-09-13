class_name PlayerNavigator

extends NavigationAgent2D

@export var is_on: bool = false

@onready var player_controller: PlayerCharacter = $".."

@export var force: float = 100.0  # Adjustable force value

func _process(delta: float) -> void:
    if is_on:
        if not is_navigation_finished():
            var next_point = get_next_path_position()
            var direction = (next_point - player_controller.global_position).normalized()
            player_controller.apply_central_force(direction * force)
