extends TileMapLayer

@export var water: Node2D
@export var water_vertical_buffer: float = 5.0
@onready var mask_out_area: Area2D

func _ready() -> void:
    water.ready.connect(func(): mask_out_area = water.water_area)

func _process(delta: float) -> void:
    var screen_rect = get_collision_shape_screen_rect(water.collision_shape_2d)
    var screen_rect_position = screen_rect.position
    var screen_rect_size = screen_rect.size
    var water_debug_screen_rect: ColorRect = %WaterDebugScreenRect
    if is_instance_valid(water_debug_screen_rect):
      water_debug_screen_rect.position = screen_rect_position
      water_debug_screen_rect.size = screen_rect_size
    var mat: ShaderMaterial = material
    material.set_shader_parameter("rect_position", screen_rect_position)
    material.set_shader_parameter("rect_size", screen_rect_size)

func get_collision_shape_screen_rect(collision_shape: CollisionShape2D) -> Rect2:
    var global_transform = collision_shape.get_global_transform_with_canvas()
    var rect_shape = collision_shape.shape
    if rect_shape is RectangleShape2D:
        var extents = rect_shape.extents
        var local_corners = [
            Vector2(-extents.x, -extents.y - water_vertical_buffer),
            Vector2(extents.x, -extents.y - water_vertical_buffer),
            Vector2(extents.x, extents.y),
            Vector2(-extents.x, extents.y)
        ]
        var global_corners = []
        for corner in local_corners:
            global_corners.append(global_transform * corner)
        var trans = collision_shape.get_viewport_transform()
        var c_trans = collision_shape.get_canvas_transform()
        var min_x = min(global_corners[0].x, global_corners[1].x, global_corners[2].x, global_corners[3].x)
        var max_x = max(global_corners[0].x, global_corners[1].x, global_corners[2].x, global_corners[3].x)
        var min_y = min(global_corners[0].y, global_corners[1].y, global_corners[2].y, global_corners[3].y)
        var max_y = max(global_corners[0].y, global_corners[1].y, global_corners[2].y, global_corners[3].y)
        var screen_rect = Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))
        var g_trans = collision_shape.get_global_transform()

        return screen_rect

    return Rect2()
