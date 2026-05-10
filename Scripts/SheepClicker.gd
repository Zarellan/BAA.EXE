extends Node2D

var isInside = false

var twe:Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TweenUtils.tweenSkewPingPong(self,-0.04,0.04,1,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (isInside && Input.is_action_just_pressed("LeftMouse")):
		print("PRESSED YAY")
	pass


func _on_static_body_2d_mouse_entered() -> void:
	isInside = true
	pass # Replace with function body.


func _on_static_body_2d_mouse_exited() -> void:
	isInside = false
	pass # Replace with function body.
