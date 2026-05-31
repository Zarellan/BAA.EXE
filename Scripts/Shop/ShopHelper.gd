extends Control



@export var scroller:ScrollContainer
@export var scrollerRebirth:ScrollContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (isUp):
		ScrollType(-8)
	if (isDown):
		ScrollType(8)
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
