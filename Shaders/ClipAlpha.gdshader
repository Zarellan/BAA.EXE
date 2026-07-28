shader_type canvas_item;

// Controls the parent's visual alpha without affecting the "Clip Children" system
uniform float parent_visual_alpha : hint_range(0.0, 1.0) = 0.5;
// Allows you to tint the parent without using modulate
uniform vec4 parent_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0); 
// Tolerance for black pixel clipping
uniform float black_threshold : hint_range(0.0, 1.0) = 0.05;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Check if the pixel is black
    bool is_black = tex_color.r < black_threshold && tex_color.g < black_threshold && tex_color.b < black_threshold;
    
    if (is_black) {
        // Discarding the pixel here tells Clip Children: "This spot is empty, don't show kids here"
        discard; 
    }
    
    // Apply the custom tint and visual alpha ONLY to the parent's rendering
    COLOR = tex_color * parent_tint;
    COLOR.a *= parent_visual_alpha;
}