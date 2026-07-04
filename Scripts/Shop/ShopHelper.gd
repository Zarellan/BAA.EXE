extends Control
class_name ShopHelper
@export var scroller:ScrollContainer
@export var scrollerRebirth:ScrollContainer

func _process(delta: float) -> void:
	if (isUp):
		ScrollType(-8 * delta * 100)
	if (isDown):
		ScrollType(8 * delta * 100)
	if (DeviceCheckerUtil.IsUsingPhone()):
		ScrollBySwipe()
	pass

var isUp = false

func _on_up_button_down() -> void:
	isUp = true
	pass # Replace with function body.


func _on_up_button_up() -> void:
	isUp = false
	pass # Replace with function body.

var isDown = false

func _on_down_button_up() -> void:
	isDown = false
	pass # Replace with function body.


func _on_down_button_down() -> void:
	isDown = true
	pass # Replace with function body.

func ScrollType(num):
	if (OptionUI.isShop):
		scroller.scroll_vertical += num
	else:
		scrollerRebirth.scroll_vertical += num

var last_mouse_position := Vector2.ZERO
var dragging := false
static var totalSwipe:float = 0
func ScrollBySwipe():
	var mousePosition:Vector2 = get_local_mouse_position()
	dragging = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if dragging && (scroller.get_global_rect().has_point(mousePosition) || scrollerRebirth.get_global_rect().has_point(mousePosition)):
		var current = get_global_mouse_position()
		var deltaY = current.y - last_mouse_position.y
		if (last_mouse_position.y > 0.0):
			ScrollType(-deltaY)
			totalSwipe += abs(deltaY)
		last_mouse_position = current
		
	elif !dragging:
		last_mouse_position = Vector2.ZERO
		totalSwipe = 0
