shader_type canvas_item;

void fragment() {
    // Get the original pixel color from the texture
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Get the color after Godot applies the modulate/self_modulate
    vec4 final_color = tex_color * COLOR;
    
    // Check if the pixel is black AND it wasn't originally transparent
    if (tex_color.r < 0.01 && tex_color.g < 0.01 && tex_color.b < 0.01 && tex_color.a > 0.01) {
        // Force alpha to 1.0 only for the naturally opaque black pixels
        final_color.a = 1.0;
    }
    
    // Output the final color
    COLOR = final_color;
}