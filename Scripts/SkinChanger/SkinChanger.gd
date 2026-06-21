extends Node2D
class_name SkinChanger

static var isSkinChanging = false

@export var sheep:Sheep
@export var textSkin:AutoSizeRichTextLabel
@export var textDescSkin:AutoSizeRichTextLabel
@export var textEffectSkin:AutoSizeRichTextLabel

var currentSkin:String
var skinClass:Skins
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skinClass = sheep.skins
	currentSkin = GameHandler.saveDataAchievements.skinUsed
	
	textSkin.text = currentSkin
	textDescSkin.text = GameHandler.saveDataAchievements.skins[skinClass.index].description
	isSkinChanging = false
	pass # Replace with function body.

func InitializeSkin():
	skinClass = sheep.skins
	currentSkin = GameHandler.saveDataAchievements.skinUsed
	
	textSkin.text = currentSkin
	textDescSkin.text = GameHandler.saveDataAchievements.skins[skinClass.index].description

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_right")):
		ChangeSkinPlace(1)
	elif (Input.is_action_just_pressed("ui_left")):
		ChangeSkinPlace(-1)
		
	pass

var sheepSkinsMain:Skins = null
func _on_apply_skin_pressed() -> void:
	if (is_instance_valid(get_tree().get_first_node_in_group("Sheep"))):
		if (skinClass.currentSkin != GameHandler.saveDataAchievements.skinUsed\
		&& GameHandler.saveDataAchievements.skins[skinClass.index].unlocked):
			sheepSkinsMain = (get_tree().get_first_node_in_group("Sheep") as Sheep).skins
			sheepSkinsMain.SetSkinMain()
			(get_tree().get_first_node_in_group("Sheep") as Sheep).BrightSkin()
			GlobalAudio.PlayOneShot("res://Sounds/skinChanged.ogg",-2,randf_range(0.95,1.05))
	pass # Replace with function body.


func _on_left_pressed() -> void:
	ChangeSkinPlace(-1)
	pass # Replace with function body.


func _on_right_pressed() -> void:
	ChangeSkinPlace(1)
	pass # Replace with function body.

func ChangeSkinPlace(ind:int):
	skinClass.ChooseSkin(ind)
	textSkin.text = skinClass.currentSkin
	textDescSkin.text = GameHandler.saveDataAchievements.skins[skinClass.index].description
	textEffectSkin.text = GameHandler.saveDataAchievements.skins[skinClass.index].effectDescription
