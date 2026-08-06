extends Control

@export var background: TextureRect
@export var sheep: Sprite2D
@export var textTitle: Control
@export var stars:Array[Node2D]
@export var richTextStat:Control
@export var buttonToFarm:Control
@export var crown:Sprite2D

var twTextScale1:Tween
var twTextScale2:Tween

var twTextY1:Tween
var twTextY2:Tween

var currentTextY:float

var leftForFall = 0

var skewSheepTween:Tween

# Called when the node enters the scene tree for the first time.

var twScrollStats:Tween
func _ready() -> void:
	currentTextY = textTitle.position.y
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/MainMenu.mp3")
	#ResourceLoader.load_threaded_request(scenePath)
	TweenUtils.tweenScalePingPong(background,Vector2(1,1.05),Vector2(1,1),2,TweenUtils.Ease.InOutSine)
	skewSheepTween = TweenUtils.tweenSkewPingPong(sheep,-0.04,0.04,1,TweenUtils.Ease.InOutSine)
	TweenTextJump()
	ListOfStats()
	GameHandler.UnlockSkin("Glorious sheep", false)
	GameHandler.saveDataAchievements.beatedTheGame = true
	GameHandler.SaveAllDataGlob()
	GameHandler.saveDataAchievements.skinUsed = "Glorious sheep"
	if (WebsiteUtil.platformType == WebsiteUtil.Platform.crazyGames):
		WebsiteUtil.PartyPopper()
	#richTextStat.get_v_scroll_bar().value_changed.connect(func(_val):
		#TweenUtils.StopTween(twScrollStats))
	pass

var statList:Array = []
func ListOfStats():
	statList =[
	["Clicks",NumberFormat.FormatInt(GameHandler.saveDataAchievements.playerClicks)],
	["money collect","\n" + NumberFormat.FormatInt(GameHandler.saveDataAchievements.moneyCollected)],
	["rebirth collect","\n" + NumberFormat.FormatInt(GameHandler.saveDataAchievements.rebirthCollected)],
	["Platform minigame score","\n" + NumberFormat.FormatInt(GameHandler.saveDataAchievements.platformMinigameScore)],
	["Total Achievements","\n" + str(GameHandler.saveDataAchievements.skins.filter(func(skin): return skin.unlocked).size() - 1)]
	]
	richTextStat.text = ""
	for i in range(statList.size()):
		richTextStat.text += statList[i][0] +":\n"+ "[center]"+str(statList[i][1])+"[/center]" + "\n"
		if (i != statList.size()-1):
			richTextStat.text += "[hr color=black height=6]\n"
		else:
			richTextStat.text += "\n"

func TweenTextJump():
	if leftForFall <= 2: # keep jumping
		twTextY1 = TweenUtils.tweenY(textTitle, currentTextY + 20, 0.3,TweenUtils.Ease.InSine)
		twTextScale1 = TweenUtils.tweenScale(textTitle,Vector2(1.1,0.9),0.3,TweenUtils.Ease.InSine)
		twTextScale1.finished.connect(func():
				twTextY2 = TweenUtils.tweenY(textTitle, currentTextY, 0.3,TweenUtils.Ease.OutCirc)
				twTextScale2 = TweenUtils.tweenScale(textTitle,Vector2.ONE,0.3,TweenUtils.Ease.OutCirc)
				twTextScale2.finished.connect(TweenTextJump))
		leftForFall += 1
	else: # poor sheep
		twTextY1 = TweenUtils.tweenY(textTitle, currentTextY + 230, 0.7,TweenUtils.Ease.InSine)
		twTextScale1 = TweenUtils.tweenScale(textTitle,Vector2(1.1,0.9),0.7,TweenUtils.Ease.InSine)
		twTextScale1.finished.connect(func():
				TweenUtils.StopTween(skewSheepTween)
				sheep.scale.y = 4.0
				sheep.modulate = Color(1,0,0)
				TweenUtils.tweenScaleY(sheep,4.73,1,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenColorRGB(sheep,Color(1,1,1),1,TweenUtils.Ease.OutCirc)
				for i in range(stars.size()):
					TweenUtils.tweenAlpha(stars[i],1,0.3,TweenUtils.Ease.linear)
				skewSheepTween = TweenUtils.tweenSkewPingPong(sheep,-0.04,0.04,0.3,TweenUtils.Ease.InOutSine)
				currentTextY = textTitle.position.y
				twTextY2 = TweenUtils.tweenY(textTitle, currentTextY - 50, 0.3,TweenUtils.Ease.OutCirc)
				twTextScale2 = TweenUtils.tweenScale(textTitle,Vector2.ONE,0.3,TweenUtils.Ease.OutCirc)
				twTextScale2.finished.connect(func():
					TweenUtils.tweenY(textTitle, currentTextY + 380, 0.7,TweenUtils.Ease.InSine)
					await get_tree().create_timer(1.5).timeout
					TweenUtils.tweenX(get_node("CanvasLayer/Control/SheepHolder"),419,1,TweenUtils.Ease.OutCirc)
					TweenUtils.tweenY(get_node("CanvasLayer/RichTextUuuhLabel"),99.0,1,TweenUtils.Ease.OutCirc)
					twScrollStats = TweenUtils.tweenCustom(self,richTextStat.get_v_scroll_bar().value,richTextStat.get_v_scroll_bar().max_value - richTextStat.get_v_scroll_bar().page,4,TweenUtils.Ease.InOutSine,func(val):
						richTextStat.get_v_scroll_bar().value = val)
					TweenUtils.tweenX(buttonToFarm,1130.0,1.2,TweenUtils.Ease.OutCirc)
					TweenUtils.tweenY(crown,-351.0,1.2,TweenUtils.Ease.InSine).finished.connect(func():
						crown.reparent(sheep))))
					

var isMouseInside:bool = false
func _process(_delta: float) -> void:
	if (isMouseInside && (Input.is_action_just_pressed("zoom-in") || Input.is_action_just_pressed("zoom-out"))):
		TweenUtils.StopTween(twScrollStats)

	ScrollBySwipe()

func _on_stats_mouse_entered() -> void:
	isMouseInside = true
	pass # Replace with function body.


func _on_stats_mouse_exited() -> void:
	isMouseInside = false
	pass # Replace with function body.

var last_mouse_position := Vector2.ZERO
var dragging := false
static var totalSwipe:float = 0
func ScrollBySwipe():
	var mousePosition:Vector2 = get_local_mouse_position()
	dragging = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if dragging && (richTextStat.get_global_rect().has_point(mousePosition)):
		var current = get_global_mouse_position()
		var deltaY = current.y - last_mouse_position.y
		if (last_mouse_position.y > 0.0):
			richTextStat.get_v_scroll_bar().value += -deltaY
			totalSwipe += abs(deltaY)
			TweenUtils.StopTween(twScrollStats)
		last_mouse_position = current
	elif !dragging:
		last_mouse_position = Vector2.ZERO
		totalSwipe = 0


func _on_back_to_farm_pressed() -> void:
	TransitionScript.ChangeScene("res://Scenes/MainFarm.tscn",func():
				GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/lesiakower-morning-coffee-396750.mp3"))
	pass # Replace with function body.
