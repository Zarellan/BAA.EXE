extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	if (get_global_rect().has_point(mouse_pos) && Input.is_action_pressed("touching")):
		print("ff")
	pass
