class_name JumpArrow
extends Control

signal jump(angle: float, power: float)

@onready var arrow_rotation_pivot: Marker2D = %ArrowRotationPivot

@onready var texture_rect: TextureRect = $TextureRect

var pivot_location: Vector2
var mouse_button_held: bool = false

func _ready() -> void:
    pivot_location = pivot_offset
    visible = false

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                mouse_button_held = true
                visible = true
            else:
                mouse_button_held = false
                visible = false
                var mouse_pos = get_global_mouse_position()
                var direction = mouse_pos - arrow_rotation_pivot.global_position
                var angle = direction.angle() + 1.5 * PI
                var power = direction.length()
                rotation = angle
                jump.emit(rotation - 1.5 * PI, power)

func _process(delta: float) -> void:
    if mouse_button_held:
        var mouse_pos = get_global_mouse_position()
        var direction = mouse_pos - arrow_rotation_pivot.global_position
        var angle = direction.angle() + 1.5 * PI
        texture_rect.scale = direction.length() * Vector2(1, 1) / 18.0
        texture_rect.scale.y = direction.length() / 18.0
        rotation = angle
