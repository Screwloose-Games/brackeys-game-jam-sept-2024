shader_type canvas_item;

uniform vec2 rect_position; // The position of the rectangle (top-left corner)
uniform vec2 rect_size;     // The size of the rectangle (width, height)

void fragment() {
    vec2 pixel_pos = FRAGCOORD.xy; // The position of the current pixel

    // Check if the pixel is within the rectangle's bounds
    if (pixel_pos.x > rect_position.x && pixel_pos.x < rect_position.x + rect_size.x &&
        pixel_pos.y > rect_position.y && pixel_pos.y < rect_position.y + rect_size.y) {
        discard; // Discard the pixel if it's within the rectangle
    }

    // Normal rendering for other pixels can go here
    //COLOR = texture(TEXTURE, UV);
}
