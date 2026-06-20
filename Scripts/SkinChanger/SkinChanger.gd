extends Node2D
class_name SkinChanger

static var isSkinChanging = true

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
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_right")):
		skinClass.ChooseSkin(1)
		textSkin.text = skinClass.currentSkin
		textDescSkin.text = GameHandler.saveDataAchievements.skins[skinClass.index].description
		textEffectSkin.text = GameHandler.saveDataAchievements.skins[skinClass.index].effectDescription
	pass

var sheepSkinsMain:Skins = null
func _on_apply_skin_pressed() -> void: # wull solve later
	sheepSkinsMain = (get_tree().get_first_node_in_group("Sheep") as Sheep).skins
	sheepSkinsMain.SetSkinMain()
	(get_tree().get_first_node_in_group("Sheep") as Sheep).BrightSkin()
	GlobalAudio.PlayOneShot("res://Sounds/skinChanged.ogg",-2,randf_range(0.95,1.05))
	pass # Replace with function body.
