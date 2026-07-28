shader_type canvas_item;

// Controls the white flash intensity (0.0 = completely invisible, 1.0 = pure white overlay)
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Simply render solid white, and control the visibility via the modifier
    COLOR = vec4(1.0, 1.0, 1.0, flash_modifier);
}