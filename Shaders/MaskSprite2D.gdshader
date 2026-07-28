shader_type canvas_item;

// The mask from viewport
uniform sampler2D mask;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);       // target sprite
    vec4 mask_tex = texture(mask, UV);     // mask from viewport

    // Keep modulate and apply mask alpha
    COLOR = tex * COLOR;       // modulate stays
    COLOR.a *= mask_tex.a;     // mask alpha applied
}