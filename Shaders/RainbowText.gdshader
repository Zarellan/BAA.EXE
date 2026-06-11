shader_type canvas_item;

/// Animation speed — higher values spin the hue faster.
uniform float speed : hint_range(0.1, 4.0) = 0.9;
/// How strongly the rainbow overrides the original sprite color (0.0 = invisible, 1.0 = pure rainbow).
uniform float rainbow_mix : hint_range(0.0, 1.0) = 0.5;
/// Brightness multiplier applied to the rainbow colour.
uniform float glow_intensity : hint_range(1.0, 3.5) = 1.5;
/// Actual pixel dimensions of a SINGLE frame of your animation.
uniform vec2 node_size = vec2(64.0, 64.0);

// --- OUTLINE SETTINGS ---
/// Toggle whether the outline gets the rainbow effect (true) or uses the solid outline_color (false).
uniform bool rainbow_outline = true;
/// Width of the outline in pixels. Increase this in inspector to see it!
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;
/// The solid color used for the outline if rainbow_outline is false.
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

varying vec2 local_uv;
varying vec4 modulate_color;

void vertex() {
	local_uv = vec2(float(VERTEX_ID == 1 || VERTEX_ID == 2), float(VERTEX_ID == 2 || VERTEX_ID == 3));
	modulate_color = COLOR;
}

vec3 hsv_to_rgb(vec3 c) {
	vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
	return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	// 1. Get standard sprite alpha and color
	vec4 sprite_color = texture(TEXTURE, UV);
	
	// 2. Compute the rainbow color pattern
	vec2 pixel = local_uv * node_size;
	float denom = max(node_size.x + node_size.y, 1.0);
	float phase = (pixel.x + pixel.y) / denom;
	float hue = fract(TIME * speed * 0.25 + phase);
	vec3 rainbow = hsv_to_rgb(vec3(hue, 1.0, 1.0)) * glow_intensity;

	// 3. Precise color trick check (safeguards against anti-aliasing edge artifacts)
	float active_mix = rainbow_mix;
	if (modulate_color.r < 0.95 || modulate_color.g < 0.95 || modulate_color.b < 0.95) {
		active_mix = 0.0; 
	}

	// 4. Mix the main body color
	vec3 body_rgb = mix(sprite_color.rgb, rainbow, active_mix);

	// 5. ENHANCED OUTLINE SAMPLING
	// Calculate dynamic step sizes relative to the screen/texture pixel map
	vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
	
	// Sample in 4 diagonal offsets to secure full outline coverage around edges
	float total_alpha = sprite_color.a;
	total_alpha = max(total_alpha, texture(TEXTURE, UV + vec2(-size.x, -size.y)).a);
	total_alpha = max(total_alpha, texture(TEXTURE, UV + vec2(size.x, -size.y)).a);
	total_alpha = max(total_alpha, texture(TEXTURE, UV + vec2(-size.x, size.y)).a);
	total_alpha = max(total_alpha, texture(TEXTURE, UV + vec2(size.x, size.y)).a);
	
	// Separate text body from outline zone
	float outline_factor = clamp(total_alpha - sprite_color.a, 0.0, 1.0);

	// 6. Color selection for outline zone (FIXED: Removed 'active_mix > 0.0' requirement)
	vec3 current_outline_color;
	if (rainbow_outline) {
		current_outline_color = rainbow;
	} else {
		current_outline_color = outline_color.rgb;
	}

	// 7. FINAL SOLID COMPOSITING
	vec4 final_output = vec4(0.0);
	if (sprite_color.a > 0.0) {
		final_output = vec4(body_rgb * modulate_color.rgb, sprite_color.a * modulate_color.a);
	} else if (outline_factor > 0.0) {
		// Use the outline factor to respect the alpha falloff of the outline edge
		final_output = vec4(current_outline_color * modulate_color.rgb, outline_factor * modulate_color.a);
	}

	COLOR = final_output;
}