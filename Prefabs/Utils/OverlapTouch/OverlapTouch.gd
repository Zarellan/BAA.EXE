extends TextureRect

signal touched
signal untouched

@export var rawMath = false
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if (!rawMath && !DeviceCheckerUtil.IsUsingPhone()):
		BuiltIn()
	else:
		RawMath()


func BuiltIn():
	if enteredMouse && Input.is_action_pressed("touching"):
		touched.emit()
	else:
		untouched.emit()

func RawMath():
	var local_mouse_pos = get_local_mouse_position()
	
	var local_rect = Rect2(Vector2.ZERO, size) 
	
	if local_rect.has_point(local_mouse_pos) && Input.is_action_pressed("touching"):
		touched.emit()
	else:
		untouched.emit()

var enteredMouse = false
func _on_mouse_entered() -> void:
	enteredMouse = true
	pass


func _on_mouse_exited() -> void:
	enteredMouse = false
	pass
