extends Control
class_name AchievementHandler
static var isAchievement = false

@export var achievementPrefab:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isAchievement = false
	for i in range(GameHandler.saveDataAchievements.skins.size()):
		var ls = GameHandler.saveDataAchievements.skins[i]
		if (ls.achievementName == "None"): #skip default one
			continue
		var pref = InstantiateUtil.Instantiate(achievementPrefab,$TextureRect/ScrollContainer/VBoxContainer)
		(pref as AchievementItem).SetAchieve(ls)
	
	position.y = -get_rect().size.y
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (isAchievement && Input.is_action_just_pressed("ui_cancel")):
		ExitAchievement()
	pass

var achieveTween:Tween
func BringAchievement():
	if !isAchievement:
		TweenUtils.StopTween(achieveTween)
		achieveTween = TweenUtils.tweenY(self,0.0,0.3,TweenUtils.Ease.OutCirc)
		isAchievement = true
		visible = true
func ExitAchievement():
	if isAchievement:
		TweenUtils.StopTween(achieveTween)
		achieveTween = TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		isAchievement = false
		achieveTween.finished.connect(func():
			visible = false)

func _on_achievements_pressed() -> void:
	BringAchievement()
	GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_button_pressed() -> void:
	ExitAchievement()
	pass # Replace with function body.
