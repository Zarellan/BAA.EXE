extends Control
class_name AchievementItem

static var achievementItem:Dictionary[String, AchievementItem]

@export var title:Control
@export var description:Control
@export var image:Control

var itemAchive:SkinItem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	achievementItem[itemAchive.achievementName] = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SetAchieve(item:SkinItem):
	title.text = item.achievementName
	description.text = item.achievementTask
	image.texture = item.achievementImage
	itemAchive = item
	AchievementUpdate()
	

func AchievementUpdate(): # avoiding using process to save some performance
	if (itemAchive.unlocked):
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		modulate = Color(0.443, 0.443, 0.443, 1.0)
