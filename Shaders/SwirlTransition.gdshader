shader_type canvas_item;

uniform float progress : hint_range(0, 1);
uniform float diamondPixelSize = 10.0;

void fragment() {

	// convert to pixel space
	vec2 pixel_pos = SCREEN_UV / SCREEN_PIXEL_SIZE;

	float xFraction = fract(pixel_pos.x / diamondPixelSize);
	float yFraction = fract(pixel_pos.y / diamondPixelSize);

	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);

	if (xDistance + yDistance + UV.x + UV.y > progress * 4.0) {
		discard;
	}
}