shader_type canvas_item;

uniform float mix_weight : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // 1. Get the original texture pixel
    vec4 texture_color = texture(TEXTURE, UV);
    
    // 2. Mix the texture's RGB with solid white
    vec3 flashed_rgb = mix(texture_color.rgb, vec3(1.0), mix_weight);
    
    // 3. Combine texture alpha with the modulate alpha (COLOR.a)
    float final_alpha = texture_color.a * COLOR.a;
    
    // 4. Output the final color
    COLOR = vec4(flashed_rgb, final_alpha);
}