shader_type canvas_item;
render_mode unshaded;

uniform sampler2D gradient : source_color;
uniform float gradient_mix_amount = 1.0;

// REPLACED TIME: Animate this from 0.0 to 1.0 via a script or AnimationPlayer!
uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform float random_start = 0.0;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	uv -= pivot;
	return vec2(cosa * uv.x - sina * uv.y, sina * uv.x + cosa * uv.y) + pivot;
}

void fragment() {
	// 1. Get the original pixel color and alpha from the texture
	vec4 text_tex = texture(TEXTURE, UV);
	
	// 2. Rotate the gradient 90 degrees around the center
	vec2 myUv = rotateUV(UV, vec2(0.5, 0.5), radians(90));
	
	// 3. Shift the UV coordinates based on our custom progress uniform instead of TIME
	myUv.x = fract(myUv.x + progress + random_start);
	
	vec3 gradientTex = texture(gradient, myUv).rgb;
	
	// 4. Convert color into grayscale value
	float greyscale_value = dot(gradientTex.rgb, vec3(0.299, 0.587, 0.114));
	
	// 5. Sample the color from your gradient palette
	vec3 sampled_color = texture(gradient, vec2(greyscale_value, 0.0)).rgb;
	vec3 final_gradient = mix(gradientTex.rgb, sampled_color, gradient_mix_amount);
	
	// 6. Apply the black outline fix
	COLOR.rgb = mix(vec3(0.0), final_gradient, text_tex.rgb);
	
	// Preserve alpha
	COLOR.a = text_tex.a;
}