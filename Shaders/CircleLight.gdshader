shader_type canvas_item;

uniform vec2 light_position = vec2(0.5, 0.5);
uniform float radius = 0.3;
uniform float softness = 0.1;

uniform vec4 light_color : source_color = vec4(1.0, 1.0, 0.8, 1.0);
uniform float intensity = 1.5;

void fragment() {

    // Distance from light center
    float dist = distance(UV, light_position);

    // Circular falloff
    float light = 1.0 - smoothstep(radius - softness, radius, dist);

    // Final light color
    vec3 final_light = light_color.rgb * light * intensity;

    // Invisible sprite, visible light only
    COLOR = vec4(final_light, light);
}