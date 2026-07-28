shader_type canvas_item;

/// Animation speed — higher values spin the hue faster.
uniform float speed : hint_range(0.1, 4.0) = 0.9;
/// How strongly the rainbow overrides the original sprite color (0.0 = invisible, 1.0 = pure rainbow).
uniform float rainbow_mix : hint_range(0.0, 1.0) = 0.5;
/// Brightness multiplier applied to the rainbow colour.
uniform float glow_intensity : hint_range(1.0, 3.5) = 1.5;
/// Actual pixel dimensions of a SINGLE frame of your animation.
uniform vec2 node_size = vec2(64.0, 64.0);

// Use varying variables to pass localized frame coordinates from vertex to fragment step
varying vec2 local_uv;
varying vec4 modulate_color;

void vertex() {
	// Reconstruct a flawless 0.0 to 1.0 UV coordinate grid for the current frame, 
	// completely bypassing spritesheet UV offsets.
	local_uv = vec2(float(VERTEX_ID == 1 || VERTEX_ID == 2), float(VERTEX_ID == 2 || VERTEX_ID == 3));
	
	// Capture Godot's Modulate / Self-Modulate color
	modulate_color = COLOR;
}

/// Converts an HSV colour to RGB.
vec3 hsv_to_rgb(vec3 c) {
	vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
	return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	// Sample the original sprite color using the engine's built-in UV (preserves animation frame)
	vec4 sprite_color = texture(TEXTURE, UV);
	
	// Convert our local frame UV to relative pixel coordinates
	vec2 pixel = local_uv * node_size;

	// Animated hue calculations locked onto the active frame mask
	float denom = max(node_size.x + node_size.y, 1.0);
	float phase = (pixel.x + pixel.y) / denom;
	float hue   = fract(TIME * speed * 0.25 + phase);
	vec3 rainbow = hsv_to_rgb(vec3(hue, 1.0, 1.0)) * glow_intensity;

	// Mix the rainbow directly onto the sprite
	vec3 final_rgb = mix(sprite_color.rgb, rainbow, rainbow_mix);

	// Render using the sprite's alpha mask and modulation colors
	COLOR.rgb = final_rgb * modulate_color.rgb;
	COLOR.a = sprite_color.a * modulate_color.a;
}