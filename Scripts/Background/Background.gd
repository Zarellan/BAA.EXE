extends Node2D

@export var nightBackground:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TweenUtils.tweenScalePingPong(nightBackground,Vector2(2.67,2.9),Vector2(2.67,2.67),2.2,TweenUtils.Ease.InOutSine)
	pass # Replace with function body.
