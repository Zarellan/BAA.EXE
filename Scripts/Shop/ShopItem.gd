extends Control
class_name ShopItem

enum Powers{
	none,
	powerClick,
	autoCollect,
	fasterAutoCollector # MUST ADD THIS
}

#@export var itemName:String = "place holder"
#@export var itemDescription:String = "this is description placeholder"
#@export var price:int = 50
#@export var power:Powers = Powers.none

@export var shopData:ShopClass

#tweens
var tweenAlpha:Tween
var tweenHolder:Tween
var tweenRotationImage:Tween

var isInside = false

var moneyNode:Control
var levelNode:Control

var originalPosXMoney

@export var coins: int = 0

func _ready() -> void:
	originalPosXMoney = get_node("Holder/Price").position.x
	moneyNode = get_node("Holder/Price")
	levelNode = get_node("Holder/Level")
	get_node("Holder/Title").text = shopData.title
	get_node("Holder/Description").text = shopData.description
	moneyNode.text = "$" + str(shopData.price)
	levelNode.text = "lv:"+ str(shopData.level)
	SetBasedOnLevel()
	pass # Replace with function body.

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
	
	if get_global_rect().has_point(mouse_pos) && !isInside:
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(get_node("BG"),170/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1.02,1.02),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),-5,0.2,TweenUtils.Ease.OutCirc)
		isInside = true
	elif !get_global_rect().has_point(mouse_pos) && isInside:
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(get_node("BG"),95.0/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1,1),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),0,0.2,TweenUtils.Ease.OutCirc)
		isInside = false

func ModifyTexts():
	moneyNode.text = "$" + str(shopData.price)
	levelNode.text = "lv:"+ str(shopData.level)

var colorTween:Tween

func TweenColor(col:Color):
	TweenUtils.StopTween(colorTween)
	moneyNode.modulate = col
	colorTween = TweenUtils.tweenColor(moneyNode,Color(1.0, 1.0, 1.0, 1.0),0.3,TweenUtils.Ease.linear)

var tweenXtext:Tween
func Bought():
	if isInside && Input.is_action_just_pressed("LeftMouse"):
		if (shopData.power == Powers.none):
			push_error("no power added")
			return
		if (GameHandler.saveData.money >= shopData.price):
			match shopData.power:
				Powers.powerClick:
					GameHandler.saveData.increment += 10
				Powers.autoCollect:
					GameHandler.saveData.autoCollect += 4
			GameHandler.saveData.money -= shopData.price
			shopData.price *= shopData.tax
			shopData.tax += shopData.taxInc
			TweenColor(Color(0.0, 0.905, 0.2, 1.0))
			if shopData.level == 0:
				TweenUtils.tweenY(moneyNode,61.0,0.3,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenScale(moneyNode,Vector2(0.8,0.8),0.3,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenAlpha(levelNode,1,0.3,TweenUtils.Ease.linear)
			shopData.level += 1
			ModifyTexts()
			#ResourceUtil.SaveResource(GameHandler.saveData,"ShopList.tres","saver")
			GameHandler.SaveAllData()
			#ResourceSaver.save(GameHandler.shopListGlob,"res://saver/ShopList.tres") # save shop list
		else:
			moneyNode.position.x = originalPosXMoney - 7
			TweenUtils.StopTween(tweenXtext)
			tweenXtext = TweenUtils.tweenX(moneyNode,originalPosXMoney,0.3,TweenUtils.Ease.OutCirc)
			TweenColor(Color(1.0, 0.0, 0.0, 1.0))
