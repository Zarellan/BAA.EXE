extends Control
class_name ShearsEffect

var entered = false

var shear1:Control
var shear2:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shear1 = get_node("Shear1")
	shear2 = get_node("Shear2")
	shear1.rotation_degrees = -27
	shear2.rotation_degrees = 27
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if DeviceCheckerUtil.IsUsingPhone(): # if using phone, it's annoying to make shear appear in random place
		return
	if entered:
		position = get_viewport().get_mouse_position() - pivot_offset
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		visible = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		visible = false
	pass

var shear1Tween:Tween
var shear2Tween:Tween

func WoolCollected():
	shear1.rotation_degrees = 5
	shear2.rotation_degrees = -5
	TweenUtils.StopTween(shear1Tween)
	TweenUtils.StopTween(shear2Tween)
	shear1Tween = TweenUtils.tweenRotation(shear1,-27,0.3,TweenUtils.Ease.OutCirc)
	shear2Tween = TweenUtils.tweenRotation(shear2,27,0.3,TweenUtils.Ease.OutCirc)

func _on_static_body_2d_mouse_entered() -> void:
	entered = true
	pass # Replace with function body.


func _on_static_body_2d_mouse_exited() -> void:
	entered = false
	pass # Replace with function body.
