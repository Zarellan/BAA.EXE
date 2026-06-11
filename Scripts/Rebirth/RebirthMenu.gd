extends Control
class_name RebirthMenu

static var isRebirthMenu:bool = false
@export var textRebirth:Control
@export var buttonRebirth:Control

var tweenRebirth:Tween

const base_rebirth:float = 25000

var base_rebirth_total:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var totalRebirth = 0.0
var calcBirth = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	base_rebirth_total = base_rebirth / GameHandler.saveDataRebirth.cheaperRebirth
	if (Input.is_action_just_pressed("Key_Q") && !isRebirthMenu):
		BringRebirth()
	elif (isRebirthMenu && (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("Key_Q"))):
		ExitRebirth()
	calcBirth = sqrt(GameHandler.saveData.money / base_rebirth_total)
	totalRebirth = calcBirth
	if (totalRebirth < 1000):
		textRebirth.text = "%.2f" %totalRebirth
	else:
		textRebirth.text = NumberFormat.Format(totalRebirth)
	if (totalRebirth < 1.0):
		(buttonRebirth as Button).disabled = true
		(buttonRebirth as Button).text = "Must atleast have\nmore than $"+NumberFormat.Format(base_rebirth_total)
		get_node("TextureRect/Rebirth/TextureRect").material.set_shader_parameter("border_px", 0)
	else:
		(buttonRebirth as Button).disabled = false
		(buttonRebirth as Button).text = "Rebirth"
		get_node("TextureRect/Rebirth/TextureRect").material.set_shader_parameter("border_px", 3.78)
	pass

func BringRebirth():
	if !isRebirthMenu:
		TweenUtils.StopTween(tweenRebirth)
		tweenRebirth = TweenUtils.tweenY(self,0.0,0.3,TweenUtils.Ease.OutCirc)
		isRebirthMenu = true
func ExitRebirth():
	if isRebirthMenu:
		TweenUtils.StopTween(tweenRebirth)
		tweenRebirth = TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		isRebirthMenu = false

func _on_back_pressed() -> void:
	ExitRebirth()
	pass # Replace with function body.


func _on_rebirth_ic_pressed() -> void:
	BringRebirth()
	pass # Replace with function body.


func _on_rebirth_pressed() -> void:
	TransitionScript.ChangeScene("res://Scenes/MainFarm.tscn",Rebirthed)
	pass # Replace with function body.

func Rebirthed():
	ResourceUtil.RemoveResources("SaveData","saver")
	GameHandler.saveData = GameSaveData.new()
	GameHandler.saveDataRebirth.rebirth += int(totalRebirth)
	GameHandler.SaveAllDataRebirth()
	isRebirthMenu = false
