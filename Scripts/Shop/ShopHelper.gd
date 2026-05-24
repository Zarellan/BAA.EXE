extends Control



@export var scroller:ScrollContainer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (isUp):
		scroller.scroll_vertical -= 8
	if (isDown):
		scroller.scroll_vertical += 8
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
