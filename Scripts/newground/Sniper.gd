extends Control
class_name SniperClass

@export var sniperRect:ColorRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var radTween:Tween
var dotTween:Tween

func SetSnipe(isSniping):
	TweenUtils.StopTween(radTween)
	TweenUtils.StopTween(dotTween)
	if isSniping:
		radTween = TweenUtils.tweenCustom(self,sniperRect.material.get_shader_parameter("radius"),0.2,0.3,TweenUtils.Ease.OutCirc,func(val):
			sniperRect.material.set_shader_parameter("radius", val))
		dotTween = TweenUtils.tweenCustom(self,sniperRect.material.get_shader_parameter("dot_radius"),0.006,0.3,TweenUtils.Ease.OutCirc,func(val):
			sniperRect.material.set_shader_parameter("dot_radius", val))
	elif !isSniping:
		radTween = TweenUtils.tweenCustom(self,sniperRect.material.get_shader_parameter("radius"),5,0.3,TweenUtils.Ease.InSine,func(val):
			sniperRect.material.set_shader_parameter("radius", val))
		dotTween = TweenUtils.tweenCustom(self,sniperRect.material.get_shader_parameter("dot_radius"),0,0.3,TweenUtils.Ease.OutCirc,func(val):
			sniperRect.material.set_shader_parameter("dot_radius", val))
func ShootEffect():
	TweenUtils.StopTween(radTween)
	radTween = TweenUtils.tweenCustom(self,0.5,0.2,0.3,TweenUtils.Ease.OutCirc,func(val):
			sniperRect.material.set_shader_parameter("radius", val))
# Inside a script attached to your ColorRect
func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport().get_visible_rect().size

	# Normalize mouse position between 0.0 and 1.0
	var normalized_pos = mouse_pos / screen_size

	# Update the shader parameter
	sniperRect.material.set_shader_parameter("center", normalized_pos)
