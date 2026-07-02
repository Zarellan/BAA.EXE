extends Control
class_name AchievementItem

@export var title:Control
@export var description:Control
@export var image:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SetAchieve(item:SkinItem):
	title.text = item.achievementName
	description.text = item.achievementTask
	image.texture = item.achievementImage
