extends RichTextEffect
class_name FadeColorEffect

var bbcode = "colorT"

func _process_custom_fx(char_fx):

	var speed = float(char_fx.env.get("speed", 3.0))

	var start_color = Color(char_fx.env.get("sColor", "white"))
	var end_color = Color(char_fx.env.get("eColor", "red"))

	var t = sin(char_fx.elapsed_time * speed) * 0.5 + 0.5

	char_fx.color = start_color.lerp(end_color, t)

	return true
