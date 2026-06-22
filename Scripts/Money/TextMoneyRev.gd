extends Control
class_name TextMoneyRev

@export var sheep:Node2D
@export var text:PackedScene

var mater:ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var sc = $"../Shop/ScrollContainer"
	#TweenUtils.tweenScrollY(sc,sc.get_v_scroll_bar().max_value,2,TweenUtils.Ease.OutCirc)
	set_process(false)
	set_physics_process(false)
	pass # Replace with function body.

func RevealMoney(textMoney = 1, color:Color = Color(1,1,1,1), rainbow = false):
	# Get the global position of a world object (e.g., the Player)
	var world_pos = sheep.global_position

	# Convert it to canvas (UI) coordinates
	var ui_pos = get_viewport().get_canvas_transform() * world_pos
	
	var tex:RichTextLabel = InstantiateUtil.Instantiate(text,self)
	tex.text = "+" + str(textMoney)
	tex.add_theme_color_override("default_color",color)
	# Assign to a UI element's global position
	tex.position = (ui_pos - tex.get_rect().size / 2) + Vector2(randf_range(-60,60),randf_range(-60,60))
	if (rainbow):
		mater = tex.material.duplicate()
		mater.set_shader_parameter("rainbow_mix", 0.5)
		tex.material = mater
	
#func EventTestAgain():
	#print("it works")
