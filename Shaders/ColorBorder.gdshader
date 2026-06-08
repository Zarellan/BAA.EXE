shader_type canvas_item;

/// Width of the shimmering rainbow border in pixels.
uniform float border_px : hint_range(2.0, 24.0) = 2.0;
/// Animation speed — higher values spin the gradient faster.
uniform float speed : hint_range(0.1, 4.0) = 0.9;
/// Brightness multiplier applied to the border colour (creates a glow effect).
uniform float glow_intensity : hint_range(1.0, 3.5) = 2.0;
/// Actual pixel dimensions of the node this material is applied to.
uniform vec2 node_size = vec2(64.0, 64.0);
/// If true, the center texture is hidden and only the border is shown.
uniform bool only_border = false;

/// The custom gradient resource used for the border color.
/// In the Inspector, assign a GradientTexture2D here.
uniform sampler2D border_gradient : source_color, filter_linear, repeat_enable;

void fragment() {
	// original_color contains the texture color multiplied by the node's Modulate color.
	// If only_border is true, we force the background texture to be completely transparent.
	vec4 original_color = only_border ? vec4(0.0) : texture(TEXTURE, UV) * COLOR;

	// Convert UV to pixel coordinates relative to this node.
	vec2 pixel = UV * node_size;

	// Distance from the nearest edge in pixels.
	float dist_left   = pixel.x;
	float dist_right  = node_size.x - pixel.x;
	float dist_top    = pixel.y;
	float dist_bottom = node_size.y - pixel.y;
	float edge_dist   = min(min(dist_left, dist_right), min(dist_top, dist_bottom));

	if (edge_dist > border_px) {
		// Keep the modulated main texture in the center (will be blank if only_border is true)
		COLOR = original_color;
	} else {
		// Calculate the shifting coordinate for sampling the gradient
		float denom       = max(node_size.x + node_size.y, 1.0);
		float phase       = (pixel.x + pixel.y) / denom;
		float gradient_x  = fract(TIME * speed * 0.25 + phase);

		// Sample the color from your custom 2D gradient texture
		vec3 gradient_color = texture(border_gradient, vec2(gradient_x, 0.5)).rgb;

		// Alpha fades from full at the very edge to zero at the inner boundary
		float alpha = 1.0 - smoothstep(0.0, border_px, edge_dist);
		alpha = pow(alpha, 0.5) * 0.92;

		// Calculate the final border color with glow intensity
		vec4 border_color = vec4(gradient_color * glow_intensity, alpha);

		// Blend the custom gradient border ON TOP of the original texture
		COLOR = mix(original_color, border_color, border_color.a);
	}
}