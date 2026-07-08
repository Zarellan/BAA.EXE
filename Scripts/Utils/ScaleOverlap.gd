extends Node

@export var node:Control
@export var scaleVal = 1.0
@export var centerOverride = true
@export var useScalingSingle:bool = false
@export var useDefaultScale:bool = false
@export var dependOnButton:bool = false
@export var button:Control

var scaleNodeTween:Tween
var scaleNodeDef:Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (dependOnButton):
		button.mouse_entered.connect(MouseEntered)
		button.mouse_exited.connect(MouseExited)
	else:
		node.mouse_entered.connect(MouseEntered)
		node.mouse_exited.connect(MouseExited)
	scaleNodeDef = node.scale
	if (centerOverride):
		node.pivot_offset_ratio = Vector2(0.5,0.5)
	if (is_instance_valid(button)):
		TweenUtils.tweenAlphaSelf(button,0.7,0.0001,TweenUtils.Ease.OutCirc)
	set_process(false)
	set_physics_process(false)
	pass # Replace with function body.

func MouseEntered():
	TweenUtils.StopTween(scaleNodeTween)
	if (!useScalingSingle):
		scaleNodeTween = TweenUtils.tweenScale(node,Vector2(scaleVal,scaleVal),0.3,TweenUtils.Ease.OutCirc)
	else:
		scaleNodeTween = TweenUtils.tweenScale(node,ScaleDepend() * scaleVal,0.3,TweenUtils.Ease.OutCirc)
	AlphaButton(1)
	GlobalAudio.PlayOneShot("res://Sounds/menuHover.wav",5,randf_range(0.95,1.15))
	pass

func ScaleDepend():
	if (useDefaultScale):
		return scaleNodeDef
	else:
		return Vector2.ONE
func MouseExited():
	TweenUtils.StopTween(scaleNodeTween)
	scaleNodeTween = TweenUtils.tweenScale(node,scaleNodeDef,0.3,TweenUtils.Ease.OutCirc)
	AlphaButton(0.7)
	pass
	
var alphaNodeTween:Tween

func AlphaButton(val:float):
	if (is_instance_valid(button)):
		TweenUtils.StopTween(alphaNodeTween)
		alphaNodeTween = TweenUtils.tweenAlphaSelf(button,val,0.3,TweenUtils.Ease.OutCirc)
