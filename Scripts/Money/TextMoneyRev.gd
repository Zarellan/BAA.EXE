extends Control
class_name TextMoneyRev

@export var sheep:Node2D
@export var text:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func RevealMoney(textMoney = 1):
	# Get the global position of a world object (e.g., the Player)
	var world_pos = sheep.global_position

	# Convert it to canvas (UI) coordinates
	var ui_pos = get_viewport().get_canvas_transform() * world_pos
	
	var tex:RichTextLabel = InstantiateUtil.Instantiate(text,self)
	tex.text = "+" + str(textMoney)
	# Assign to a UI element's global position
	tex.position = (ui_pos - tex.get_rect().size / 2) + Vector2(randf_range(-60,60),randf_range(-60,60))
