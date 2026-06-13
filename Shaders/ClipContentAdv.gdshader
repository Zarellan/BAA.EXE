shader_type canvas_item;

// Accesses the screen/parent texture captured by the BackBufferCopy
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float black_threshold : hint_range(0.0, 1.0) = 0.05;

void fragment() {
    // 1. Get the child's natural color
    vec4 child_color = texture(TEXTURE, UV);
    
    // 2. Get the color of the parent directly behind this pixel
    vec4 parent_color = texture(screen_texture, SCREEN_UV);
    
    // 3. Check if the parent pixel is transparent
    bool is_transparent = parent_color.a < 0.01;
    
    // 4. Check if the parent pixel is black
    bool is_black = parent_color.r < black_threshold && parent_color.g < black_threshold && parent_color.b < black_threshold;
    
    // If the parent is black OR transparent, clip the child pixel
    if (is_transparent || is_black) {
        discard;
    }
    
    // Otherwise, render the child normally
    COLOR = child_color;
}