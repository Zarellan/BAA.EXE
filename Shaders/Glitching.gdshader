shader_type canvas_item;

// Captures the scene behind the ColorRect
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

group_uniforms Glitch_Settings;
uniform bool is_active = true;
uniform float shake_power : hint_range(0.0, 0.1) = 0.03;
uniform float shake_rate : hint_range(0.0, 1.0) = 0.2;
uniform float shake_speed : hint_range(0.0, 10.0) = 5.0;
uniform float shake_block_size : hint_range(1.0, 100.0) = 30.5;

// NEW: Controls how much the blocks break apart from each other
// 0.0 = All blocks slide together as a uniform wave
// 1.0 = Every block scatters in a completely random direction
uniform float randomization_amount : hint_range(0.0, 1.0) = 0.5;

// Pseudo-random function that accepts vec2 for 2D grid noise
float random(vec2 seed) {
    return fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec2 uv = SCREEN_UV; 

    if (is_active) {
        float time_step = floor(TIME * shake_speed);
        float enable_glitch = step(1.0 - shake_rate, random(vec2(time_step, 123.45)));
        
        if (enable_glitch > 0.0) {
            vec2 block_grid = floor(uv * shake_block_size);
            
            float global_noise_x = random(vec2(time_step, 45.67));
            float global_noise_y = random(vec2(76.54, time_step));
            
            float local_noise_x = random(block_grid + vec2(time_step, 0.0));
            float local_noise_y = random(block_grid + vec2(0.0, time_step));
            
            float final_noise_x = mix(global_noise_x, local_noise_x, randomization_amount);
            float final_noise_y = mix(global_noise_y, local_noise_y, randomization_amount);
            
            uv.x += (final_noise_x - 0.5) * shake_power;
            uv.y += (final_noise_y - 0.5) * shake_power;
        }
    }

    // Sample the background scene
    vec4 glitched_color = texture(screen_texture, uv);
    
    // ADJUSTED: Instead of a harsh discard that breaks on large ColorRects, 
    // we only discard if BOTH the glitched pixel AND the original position are empty.
    vec4 original_pixel = texture(screen_texture, SCREEN_UV);
    if (glitched_color.a < 0.01 && original_pixel.a < 0.01) {
        discard;
    }
    
    COLOR = glitched_color;
}