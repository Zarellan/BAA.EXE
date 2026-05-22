extends Sprite2D

@export var start = 1.0;
@export var end = 1.0;
@export var duration = 1.0;

@export var preShadowObj:Node2D
@export var start_preShadow = 1.0;
@export var end_preShadow = 1.0;

@export var shadowObj:Node2D
@export var start_shadow = 1.0;
@export var end_shadow = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TweenUtils.tweenSkewPingPong(self,deg_to_rad(end),deg_to_rad(start),duration,TweenUtils.Ease.InOutSine)
	TweenUtils.tweenSkewPingPong(preShadowObj,deg_to_rad(end_preShadow),deg_to_rad(start_preShadow),duration,TweenUtils.Ease.InOutSine)
	TweenUtils.tweenSkewPingPong(shadowObj,deg_to_rad(end_shadow),deg_to_rad(start_shadow),duration,TweenUtils.Ease.InOutSine)
	pass # Replace with function body.
