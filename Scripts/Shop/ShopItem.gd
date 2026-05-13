extends Control
class_name ShopItem

enum Powers{
	none,
	powerClick
}

@export var itemName:String = "place holder"
@export var itemDescription:String = "this is description placeholder"
@export var price:int = 50
@export var power:Powers = Powers.none

#tweens
var tweenAlpha:Tween
var tweenHolder:Tween
var tweenRotationImage:Tween

var isInside = false

var moneyNode:Control

var originalPosXMoney
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	originalPosXMoney = get_node("Holder/Price").position.x
	moneyNode = get_node("Holder/Price")
	get_node("Holder/Title").text = itemName
	get_node("Holder/Description").text = itemDescription
	moneyNode.text = "$" + str(price)
	pass # Replace with function body.


func set_item(title:String, desc:String, pric:int, po: Powers):
	itemName = title
	itemDescription = desc
	price = pric
	power = po
# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func Bought():
	if isInside && Input.is_action_just_pressed("LeftMouse"):
		if (power == Powers.none):
			push_error("no power added")
		if (GameHandler.money >= price):
			match power:
				Powers.powerClick:
					GameHandler.increment += 10
			GameHandler.money -= price
			TweenUtils.tweenY(moneyNode,61.0,0.3,TweenUtils.Ease.OutCirc)
		else:
			moneyNode.position.x = originalPosXMoney - 7
			TweenUtils.tweenX(moneyNode,originalPosXMoney,0.3,TweenUtils.Ease.OutCirc)
			moneyNode.modulate = Color(1.0, 0.0, 0.0, 1.0)
			TweenUtils.tweenColor(moneyNode,Color(1,1,1,1),0.3,TweenUtils.Ease.OutCirc)
