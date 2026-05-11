extends TextureRect


@export var target:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get the global position of a world object (e.g., the Player)
	var world_pos = target.global_position

	# Convert it to canvas (UI) coordinates
	var ui_pos = get_viewport().get_canvas_transform() * world_pos

	# Assign to a UI element's global position
	position = ui_pos - get_rect().size / 2
	pass
