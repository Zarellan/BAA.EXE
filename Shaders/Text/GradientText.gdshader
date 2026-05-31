shader_type canvas_item;
render_mode unshaded;

uniform sampler2D gradient : source_color;
uniform float gradient_mix_amount = 1.0;

// NEW: Controls how fast the gradient moves. Set to 0.0 to freeze it!
uniform float movement_speed = 1.0;
 
uniform float random_start = 0.0;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	uv -= pivot;
	return vec2(cosa * uv.x - sina * uv.y, cosa * uv.y + sina * uv.x) + pivot;
}
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void fragment() {
	float gradient_Rand = rand(vec2(TIME,0.0));
	// 1. Get the original pixel color and alpha from the text/font texture
	vec4 text_tex = texture(TEXTURE, UV);
	
	// 2. Rotate the gradient 90 degrees around the center
	vec2 myUv = rotateUV(UV, vec2(0.5, 0.5), radians(90));
	
	// NEW: Shift the UV coordinates over time based on our movement speed.
	// We use "fract()" to keep the numbers small and prevent floating-point precision bugs.
	myUv.x = fract(myUv.x + (TIME * movement_speed) + random_start);
	
	vec3 gradientTex = texture(gradient, myUv).rgb;
	
	// 3. Convert color into grayscale value
	float greyscale_value = dot(gradientTex.rgb, vec3(0.299, 0.587, 0.114));
	
	// 4. Sample the color from your gradient palette
	vec3 sampled_color = texture(gradient, vec2(greyscale_value, 0.0)).rgb;
	vec3 final_gradient = mix(gradientTex.rgb, sampled_color, gradient_mix_amount);
	
	// 5. Apply the black outline fix
	COLOR.rgb = mix(vec3(0.0), final_gradient, text_tex.rgb);
	
	// Preserve alpha
	COLOR.a = text_tex.a;
}