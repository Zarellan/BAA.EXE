shader_type canvas_item;

varying float modulate_alpha;

/// Width of the shimmering rainbow border in pixels.
uniform float border_px : hint_range(0.0, 24.0) = 4.0;
/// Animation speed — higher values spin the gradient faster.
uniform float speed : hint_range(0.1, 4.0) = 0.9;
/// Brightness multiplier applied to the border colour (creates a glow effect).
uniform float glow_intensity : hint_range(1.0, 3.5) = 2.0;
/// Actual pixel dimensions of the node this material is applied to.
uniform vec2 node_size = vec2(64.0, 64.0);
/// If true, the center texture is hidden and only the border is shown.
uniform bool only_border = false;

/// The custom gradient resource used for the border color.
uniform sampler2D border_gradient : source_color, filter_linear, repeat_enable;

void vertex() {
	modulate_alpha = COLOR.a;
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec4 original_color = tex_color * COLOR;

	vec2 ps = TEXTURE_PIXEL_SIZE;
	
	// We look for transparency around the current pixel to find the INSIDE edge
	float min_alpha = 1.0;
	
	for (float x = -border_px; x <= border_px; x += 1.0) {
		for (float y = -border_px; y <= border_px; y += 1.0) {
			if (x*x + y*y <= border_px*border_px) {
				vec2 offset = vec2(x, y) * ps;
				// Clamp UVs to prevent sampling wrapping artifacts at texture boundaries
				vec2 sampled_uv = clamp(UV + offset, vec2(0.0), vec2(1.0));
				float sample_alpha = texture(TEXTURE, sampled_uv).a;
				
				// If we hit the absolute edge of the texture file, treat it as transparency
				if (UV.x + offset.x < 0.0 || UV.x + offset.x > 1.0 || UV.y + offset.y < 0.0 || UV.y + offset.y > 1.0) {
					sample_alpha = 0.0;
				}
				
				min_alpha = min(min_alpha, sample_alpha);
			}
		}
	}

	// This factor is 1.0 if we are near a transparent edge, and 0.0 deep inside the sprite
	float border_factor = (1.0 - min_alpha) * tex_color.a;

	// Calculate shifting coordinate for the gradient color
	vec2 pixel = UV * node_size;
	float denom = max(node_size.x + node_size.y, 1.0);
	float phase = (pixel.x + pixel.y) / denom;
	float gradient_x = fract(TIME * speed * 0.25 + phase);
	vec3 gradient_color = texture(border_gradient, vec2(gradient_x, 0.5)).rgb;

	// Establish the base sprite color processing (including the black pixel fix)
	vec4 base_color = original_color;
	bool is_black = (tex_color.r < 0.05 && tex_color.g < 0.05 && tex_color.b < 0.05);
	bool is_opaque_in_texture = (tex_color.a > 0.05);

	if (is_black && is_opaque_in_texture) {
		base_color.a = tex_color.a; // Keep solid black fully opaque
	} else {
		base_color.a = tex_color.a * modulate_alpha; // Fade normally
	}

	if (only_border) {
		// Only display the glowing outline frame
		COLOR = vec4(gradient_color * glow_intensity, border_factor * modulate_alpha);
	} else {
		// Blend the rainbow border directly ON TOP of the inner edges of the sprite
		vec4 border_output = vec4(gradient_color * glow_intensity, border_factor * modulate_alpha);
		COLOR = mix(base_color, border_output, border_factor);
	}
}