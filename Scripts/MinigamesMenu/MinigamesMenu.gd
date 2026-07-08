extends Control
class_name MinigamesMenu

static var isMinigame = false
var canInteract:bool = true
@export var minigames:Array[MinigameType]

@export var title:Control
@export var desc:Control
@export var image:Control
@export var multi:Control

@export var gameButton:Control
var index = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ChangeMinigame(0)
	isMinigame = false
	canInteract = true
	visible = false
	pass # Replace with function body.

var achieveTween:Tween
func BringMinigame():
	if !isMinigame:
		TweenUtils.StopTween(achieveTween)
		achieveTween = TweenUtils.tweenY(self,0.0,0.3,TweenUtils.Ease.OutCirc)
		isMinigame = true
		visible = true
func ExitMinigame():
	if isMinigame:
		TweenUtils.StopTween(achieveTween)
		achieveTween = TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		isMinigame = false
		achieveTween.finished.connect(func():
			visible = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (!canInteract):
		return
	if (isMinigame && Input.is_action_just_pressed("ui_cancel")):
		ExitMinigame()
	if Input.is_action_just_pressed("ui_right"):
		ChangeMinigame(1)
	pass

func ChangeMinigame(ind:int):
	index += ind
	IndexRangeLimit(minigames)
	if (index < minigames.size()):
		title.text = minigames[index].name
		desc.text = minigames[index].description
		image.texture = minigames[index].image
		multi.text = ":x" + MultiplierInfo(minigames[index].name)
	else:
		title.text = "Coming Soon"
		desc.text = ""
		multi.text = "???"
		image.texture = load("res://Sprites/MinigamesImages/wholeBlack.png")
func IndexRangeLimit(indexMax:Array):
	if (indexMax.size() < index):
		index = 0
	elif (index < 0):
		index = indexMax.size()


func _on_texture_button_pressed() -> void:
	GoToMinigame()
	pass # Replace with function body.

func GoToMinigame():
	if (index < minigames.size()):
		TransitionScript.ChangeScene(minigames[index].sceneMinigame)
		canInteract = false

func MultiplierInfo(nam:String):
	match (nam):
		"Platform Minigame": return "%.2f" % (1 + (((GameHandler.saveDataAchievements.platformMinigameScore / 30.0))))
		_: return "???"


func _on_minigames_pressed() -> void:
	BringMinigame()
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	ExitMinigame()
	pass # Replace with function body.

func _on_left_button_pressed() -> void:
	ChangeMinigame(-1)
	pass # Replace with function body.

func _on_right_button_pressed() -> void:
	ChangeMinigame(1)
	pass # Replace with function body.


func _on_tutorial_help_pressed() -> void:
	pass # Replace with function body.
