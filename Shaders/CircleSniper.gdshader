shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius : hint_range(0.0, 5.0) = 0.2;
uniform float feather : hint_range(0.0, 0.5) = 0.05;

// Crosshair controls
uniform float line_thickness : hint_range(0.001, 0.02) = 0.004;
uniform float line_length : hint_range(0.01, 15.0) = 0.08;
uniform float line_gap : hint_range(0.0, 3.0) = 0.01;

// Center Dot controls
uniform bool show_center_dot = true;
uniform float dot_radius : hint_range(0.000, 0.05) = 0.006;

void fragment() {
    float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    
    vec2 scaled_uv = UV;
    scaled_uv.x *= aspect_ratio;
    
    vec2 scaled_center = center;
    scaled_center.x *= aspect_ratio;

    // Distance for circular hole and dot
    float dist = distance(scaled_uv, scaled_center);
    float mask = smoothstep(radius, radius + feather, dist);

    // Check if pixel is part of the 4 crosshair lines
    float dx = abs(scaled_uv.x - scaled_center.x);
    float dy = abs(scaled_uv.y - scaled_center.y);
    
    bool is_vertical_line = (dx < line_thickness) && (dy >= (radius + line_gap)) && (dy <= (radius + line_gap + line_length));
    bool is_horizontal_line = (dy < line_thickness) && (dx >= (radius + line_gap)) && (dx <= (radius + line_gap + line_length));
    bool is_crosshair = is_vertical_line || is_horizontal_line;

    // Check if pixel is part of the center dot
    bool is_dot = show_center_dot && (dist <= dot_radius);

    // Render logic: Black for crosshairs (in the border) or dot (in the center), otherwise use the sniper mask
    if ((is_crosshair && dist > radius) || is_dot) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // Solid black line or dot
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, mask); // Standard sniper mask
    }
}