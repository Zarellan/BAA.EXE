extends Node

@export var node:Control
@export var scaleVal = 1.0
@export var centerOverride = true

var scaleNodeTween:Tween
var scaleNodeDef:Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	node.mouse_entered.connect(MouseEntered)
	node.mouse_exited.connect(MouseExited)
	scaleNodeDef = node.scale
	if (centerOverride):
		node.pivot_offset_ratio = Vector2(0.5,0.5)
	if (is_instance_valid(button)):
		TweenUtils.tweenAlphaSelf(button,0.7,0.0001,TweenUtils.Ease.OutCirc)
	pass # Replace with function body.

func MouseEntered():
	TweenUtils.StopTween(scaleNodeTween)
	scaleNodeTween = TweenUtils.tweenScale(node,Vector2(scaleVal,scaleVal),0.3,TweenUtils.Ease.OutCirc)
	AlphaButton(1)
	pass

func MouseExited():
	TweenUtils.StopTween(scaleNodeTween)
	scaleNodeTween = TweenUtils.tweenScale(node,scaleNodeDef,0.3,TweenUtils.Ease.OutCirc)
	AlphaButton(0.7)
	pass
	
@export var button:Control
var alphaNodeTween:Tween

func AlphaButton(val:float):
	if (is_instance_valid(button)):
		TweenUtils.StopTween(alphaNodeTween)
		alphaNodeTween = TweenUtils.tweenAlphaSelf(button,val,0.3,TweenUtils.Ease.OutCirc)
