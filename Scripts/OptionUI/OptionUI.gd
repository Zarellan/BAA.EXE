extends Control
class_name OptionUI


@export var refresh1:Control
@export var refresh2:Control
@export var shoppingKart:Control

@export var shopPanel:Control
@export var rebirthPanel:Control
@export var upScroll:Control
@export var downScroll:Control

@export var moneyText:Control
@export var rebirthText:Control

static var isShop = true;
static var isRebirth = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rebirthPanel.position.x = 2480
	goldKartValue = ValueSaver.new()
	GoldenTweens()
	GoldKart()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Key_E") && !GameHandler.GamePausedPartil()):
		_on_shopping_kart_pressed()
	GoldUpdate()
	pass

func GoldUpdate():
	refresh1.material.set_shader_parameter("progress", goldRebirth1Value.number)
	refresh2.material.set_shader_parameter("progress", goldRebirth2Value.number)
	shoppingKart.material.set_shader_parameter("progress", goldKartValue.number)


var tweenShopPanel:Tween
var tweenUpScroll:Tween
var tweenDownScroll:Tween

var tweenMoneyText:Tween
var tweenRebirthText:Tween

func _on_shopping_kart_pressed() -> void:
	if (isRebirth):
		TweenUtils.StopTween(tweenRebirthPanel)
		tweenRebirthPanel = TweenUtils.tweenX(rebirthPanel,2480.0,0.3,TweenUtils.Ease.OutCirc)
		isRebirth = false
	if (!isShop):
		TweenUtils.StopTween(tweenShopPanel)
		tweenShopPanel = TweenUtils.tweenX(shopPanel,1240.0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenUpScroll)
		tweenUpScroll = TweenUtils.tweenAlpha(upScroll,1,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenDownScroll)
		tweenDownScroll = TweenUtils.tweenAlpha(downScroll,1,0.3,TweenUtils.Ease.OutCirc)
		isShop = true
	else:
		TweenUtils.StopTween(tweenShopPanel)
		tweenShopPanel = TweenUtils.tweenX(shopPanel,2480.0,0.3,TweenUtils.Ease.InSine)
		TweenUtils.StopTween(tweenUpScroll)
		tweenUpScroll = TweenUtils.tweenAlpha(upScroll,0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenDownScroll)
		tweenDownScroll = TweenUtils.tweenAlpha(downScroll,0,0.3,TweenUtils.Ease.OutCirc)
		isShop = false
	EnsureTextChange()
	pass # Replace with function body.

var tweenRebirthPanel:Tween


func _on_shopping_kart_rebirth_pressed() -> void:
	if (isShop):
		TweenUtils.StopTween(tweenShopPanel)
		tweenShopPanel = TweenUtils.tweenX(shopPanel,2480.0,0.3,TweenUtils.Ease.OutCirc)
		isShop = false
	if (!isRebirth):
		TweenUtils.StopTween(tweenRebirthPanel)
		tweenRebirthPanel = TweenUtils.tweenX(rebirthPanel,1240.0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenUpScroll)
		tweenUpScroll = TweenUtils.tweenAlpha(upScroll,1,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenDownScroll)
		tweenDownScroll = TweenUtils.tweenAlpha(downScroll,1,0.3,TweenUtils.Ease.OutCirc)
		isRebirth = true
	else:
		TweenUtils.StopTween(tweenRebirthPanel)
		tweenRebirthPanel = TweenUtils.tweenX(rebirthPanel,2480.0,0.3,TweenUtils.Ease.InSine)
		TweenUtils.StopTween(tweenUpScroll)
		tweenUpScroll = TweenUtils.tweenAlpha(upScroll,0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenDownScroll)
		tweenDownScroll = TweenUtils.tweenAlpha(downScroll,0,0.3,TweenUtils.Ease.OutCirc)
		isRebirth = false
	EnsureTextChange()
	pass # Replace with function body.

var goldRebirth1Tween:Tween
var goldRebirth2Tween:Tween

var goldRebirth1Value:ValueSaver
var goldRebirth2Value:ValueSaver

func GoldenTweens(): # since GPU "TIME" is heavy, I'll have to use CPU instead
	goldRebirth1Value = ValueSaver.new()
	goldRebirth2Value = ValueSaver.new()
	GoldRebirth1()
	GoldRebirth2()
	pass

func GoldRebirth1():
	goldRebirth1Value.number = 0
	goldRebirth1Tween = TweenUtils.tweenNumber(self,goldRebirth1Value,1,1.2,TweenUtils.Ease.linear)
	goldRebirth1Tween.finished.connect(GoldRebirth1)

func GoldRebirth2():
	goldRebirth2Value.number = 1
	goldRebirth2Tween = TweenUtils.tweenNumber(self,goldRebirth2Value,0,0.9,TweenUtils.Ease.linear)
	goldRebirth2Tween.finished.connect(GoldRebirth2)

var goldKartTween:Tween

var goldKartValue:ValueSaver


func GoldKart():
	goldKartValue.number = 0
	goldKartTween = TweenUtils.tweenNumber(self,goldKartValue,1,0.9,TweenUtils.Ease.linear)
	goldKartTween.finished.connect(GoldKart)
	
func EnsureTextChange():
	var rebirthAlphaVal = 0
	var moneyAlphaVal = 0
	if (isRebirth):
		rebirthAlphaVal = 1
		moneyAlphaVal = 0
	else:
		rebirthAlphaVal = 0
		moneyAlphaVal = 1
	TweenUtils.StopTween(tweenMoneyText)
	TweenUtils.StopTween(tweenRebirthText)
	TweenUtils.tweenAlpha(moneyText,moneyAlphaVal,0.3,TweenUtils.Ease.linear)
	TweenUtils.tweenAlpha(rebirthText,rebirthAlphaVal,0.3,TweenUtils.Ease.linear)
