shader_type canvas_item;

/// Animation speed — higher values spin the hue faster.
uniform float speed : hint_range(0.1, 4.0) = 0.9;
/// How strongly the rainbow overrides the original sprite color (0.0 = invisible, 1.0 = pure rainbow).
uniform float rainbow_mix : hint_range(0.0, 1.0) = 0.5;
/// Brightness multiplier applied to the rainbow colour.
uniform float glow_intensity : hint_range(1.0, 3.5) = 1.5;
/// Actual pixel dimensions of the node this material is applied to.
uniform vec2 node_size = vec2(64.0, 64.0);

// Use a varying variable to pass the modulate color from vertex to fragment step
varying vec4 modulate_color;

void vertex() {
	// In Godot 4, COLOR in vertex() holds the final Modulate * Self-Modulate value
	modulate_color = COLOR;
}

/// Converts an HSV colour to RGB.
vec3 hsv_to_rgb(vec3 c) {
	vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
	return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	// Get the original sprite color at this pixel
	vec4 sprite_color = texture(TEXTURE, UV);
	
	// Convert UV to pixel coordinates relative to this node for the wave phase.
	vec2 pixel = UV * node_size;

	// Animated hue calculations across the entire surface
	float denom = max(node_size.x + node_size.y, 1.0);
	float phase = (pixel.x + pixel.y) / denom;
	float hue   = fract(TIME * speed * 0.25 + phase);
	vec3 rainbow = hsv_to_rgb(vec3(hue, 1.0, 1.0)) * glow_intensity;

	// FIX: Directly mix the rainbow into the sprite color based on your uniform slider.
	// This ensures it shows up clearly inside, even on bright or white pixels.
	vec3 final_rgb = mix(sprite_color.rgb, rainbow, rainbow_mix);

	// Apply the captured modulate color and maintain the sprite's original transparency alpha
	COLOR.rgb = final_rgb * modulate_color.rgb;
	COLOR.a = sprite_color.a * modulate_color.a;
}