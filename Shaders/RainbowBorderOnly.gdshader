shader_type canvas_item;

/// NEW: If true, only the rainbow border is visible; the center texture is hidden.
uniform bool border_only = false;

/// Width of the shimmering rainbow border in pixels.
uniform float border_px : hint_range(2.0, 24.0) = 2.0;
/// Animation speed — higher values spin the hue faster.
uniform float speed : hint_range(0.1, 4.0) = 0.9;
/// Brightness multiplier applied to the rainbow colour (creates a glow effect).
uniform float glow_intensity : hint_range(1.0, 3.5) = 2.0;
/// Actual pixel dimensions of the node this material is applied to.
uniform vec2 node_size = vec2(64.0, 64.0);

// Use a varying variable to pass the modulate color from vertex to fragment step
varying vec4 modulate_color;

void vertex() {
	// Captures the node's Modulate / Self-Modulate settings
	modulate_color = COLOR;
}

/// Converts an HSV colour to RGB.
vec3 hsv_to_rgb(vec3 c) {
	vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
	return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	// Grab the actual texture color of your Sprite / CanvasTexture
	vec4 texture_color = texture(TEXTURE, UV);
	
	// Convert UV to pixel coordinates relative to this node.
	vec2 pixel = UV * node_size;

	// Distance from the nearest edge in pixels.
	float dist_left   = pixel.x;
	float dist_right  = node_size.x - pixel.x;
	float dist_top    = pixel.y;
	float dist_bottom = node_size.y - pixel.y;
	float edge_dist   = min(min(dist_left, dist_right), min(dist_top, dist_bottom));

	if (edge_dist > border_px) {
		if (border_only) {
			// If border_only is true, make the inside completely transparent
			COLOR = vec4(0.0);
		} else {
			// Otherwise, show the original texture
			COLOR = texture_color * modulate_color;
		}
	} else {
		// Animated hue: TIME drives the global spin; position offsets phase
		float denom  = max(node_size.x + node_size.y, 1.0);
		float phase  = (pixel.x + pixel.y) / denom;
		float hue     = fract(TIME * speed * 0.25 + phase);
		vec3  rainbow = hsv_to_rgb(vec3(hue, 1.0, 1.0));

		// Alpha fades from full at the very edge to zero at the inner boundary
		float border_alpha = 1.0 - smoothstep(0.0, border_px, edge_dist);
		border_alpha = pow(border_alpha, 0.5) * 0.92;

		// Create the glow color
		vec4 rainbow_glow = vec4(rainbow * glow_intensity, border_alpha);

		vec3 final_rgb;
		float final_alpha;

		if (border_only) {
			// If border_only is true, ignore the texture colors completely
			final_rgb = rainbow_glow.rgb;
			// Optional: cut off the border if the texture underneath is transparent (e.g. rounded UI corners)
			final_alpha = min(texture_color.a, rainbow_glow.a);
		} else {
			// Blend the rainbow border ON TOP of your texture color
			final_rgb = mix(texture_color.rgb, rainbow_glow.rgb, rainbow_glow.a);
			final_alpha = max(texture_color.a, rainbow_glow.a * 0.5);
		}

		COLOR.rgb = final_rgb * modulate_color.rgb;
		COLOR.a = final_alpha * modulate_color.a;
	}
}