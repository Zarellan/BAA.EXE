extends Control
class_name ShopItem

enum Powers{
	none,
	powerClick,
	autoCollect,
	fasterAutoCollector
}

@export var particle:PackedScene

@export var shopData:ShopClass

#tweens
var tweenAlpha:Tween
var tweenHolder:Tween
var tweenRotationImage:Tween

var isInside = false

var descriptionNode:Control
var moneyNode:Control
var levelNode:Control

var originalPosXMoney

@export var coins: int = 0

func _ready() -> void:
	originalPosXMoney = get_node("Holder/Price").position.x
	moneyNode = get_node("Holder/Price")
	levelNode = get_node("Holder/Level")
	get_node("Holder/Title").text = shopData.title
	descriptionNode = get_node("Holder/Description")
	descriptionNode.text = shopData.description
	ModifyTexts()
	CustomItemText()
	SetBasedOnLevel()
	pass # Replace with function body.
func CustomItemText(): #godot doesn't support variable inside serialize inspector, so I have to set it manually
	match shopData.power:
		Powers.fasterAutoCollector:
			descriptionNode.text = "the collector will gain every [wave amp=30.0 freq=4.0]"\
			+ str(GameHandler.saveData.collectSpeed) + "[/wave] seconds"

func SetBasedOnLevel():
	if (shopData.level > 0):
		moneyNode.position.y = 61.0
		moneyNode.scale = Vector2(0.8,0.8)
		levelNode.modulate.a = 1

func set_item(shopDat:ShopClass):
	shopData = shopDat

func _process(_delta: float) -> void:
	Hovered()
	Bought()
	pass

func Hovered():
	var mouse_pos = get_global_mouse_position()
	
	if (get_global_rect().has_point(mouse_pos) && !isInside) && !PauseScript.paused:
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(get_node("BG"),170/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1.02,1.02),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),-5,0.2,TweenUtils.Ease.OutCirc)
		isInside = true
	elif (!get_global_rect().has_point(mouse_pos) && isInside) || PauseScript.paused:
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(get_node("BG"),95.0/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1,1),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),0,0.2,TweenUtils.Ease.OutCirc)
		isInside = false

func ModifyTexts():
	moneyNode.text = "$" + str(shopData.price)
	if (shopData.canBuy):
		levelNode.text = "lv:"+ str(shopData.level)
	else:
		levelNode.text = "lv:Max"
	CustomItemText()

var colorTween:Tween

func TweenColor(col:Color):
	TweenUtils.StopTween(colorTween)
	moneyNode.modulate = col
	colorTween = TweenUtils.tweenColor(moneyNode,Color(1.0, 1.0, 1.0, 1.0),0.3,TweenUtils.Ease.linear)

var colorTweenLevel
func TweenColorLevel(col:Color):
	TweenUtils.StopTween(colorTweenLevel)
	levelNode.modulate = col
	colorTweenLevel = TweenUtils.tweenColor(levelNode,Color(1.0, 1.0, 1.0, 1.0),0.3,TweenUtils.Ease.linear)

var tweenXtext:Tween

func PowersAct():
	match shopData.power:
		Powers.powerClick:
			GameHandler.saveData.increment += 10
		Powers.autoCollect:
			GameHandler.saveData.autoCollect += 4
		Powers.fasterAutoCollector:
			GameHandler.saveData.collectSpeed -= 0.15
			if (GameHandler.saveData.collectSpeed <= 1): # custom level max
				shopData.canBuy = false

var tweenXtextLevel:Tween
func Bought():
	if isInside && Input.is_action_just_pressed("LeftMouse"):
		if (shopData.power == Powers.none):
			push_error("no power added")
			return
		print(shopData.canBuy)
		if (!shopData.canBuy):
			TweenColorLevel(Color(1,0,0,1))
			levelNode.position.x = originalPosXMoney - 7
			TweenUtils.StopTween(tweenXtextLevel)
			tweenXtextLevel = TweenUtils.tweenX(levelNode,originalPosXMoney,0.3,TweenUtils.Ease.OutCirc)
			return
		if (GameHandler.saveData.money >= shopData.price):
			PowersAct()
			GameHandler.saveData.money -= shopData.price
			shopData.price = int(floor(shopData.price * shopData.tax))
			shopData.tax += shopData.taxInc
			TweenColor(Color(0.0, 0.905, 0.2, 1.0))
			if shopData.level == 0:
				TweenUtils.tweenY(moneyNode,61.0,0.3,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenScale(moneyNode,Vector2(0.8,0.8),0.3,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenAlpha(levelNode,1,0.3,TweenUtils.Ease.linear)
			shopData.level += 1
			ModifyTexts()
			#ResourceUtil.SaveResource(GameHandler.saveData,"ShopList.tres","saver")
			var partic = InstantiateUtil.Instantiate(particle,get_tree().get_first_node_in_group("UI"))
			partic.global_position = get_node("Holder/ParticlePlace").global_position
			GameHandler.SaveAllData()
			#ResourceSaver.save(GameHandler.shopListGlob,"res://saver/ShopList.tres") # save shop list
		else:
			moneyNode.position.x = originalPosXMoney - 7
			TweenUtils.StopTween(tweenXtext)
			tweenXtext = TweenUtils.tweenX(moneyNode,originalPosXMoney,0.3,TweenUtils.Ease.OutCirc)
			TweenColor(Color(1.0, 0.0, 0.0, 1.0))
