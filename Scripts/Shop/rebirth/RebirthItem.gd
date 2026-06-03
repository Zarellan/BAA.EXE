extends Control
class_name RebirthItem

enum Powers{
	none,
	multiplier,
	offer
}

@export var particle:PackedScene

@export var shopData:RebirthClass

@export var randomSpeedTitleShade:Control
@export var randomSpeedDescriptionShade:Control


#tweens
var tweenAlpha:Tween
var tweenHolder:Tween
var tweenRotationImage:Tween

var isInside = false

var descriptionNode:Control
var moneyNode:Control
var moneyNodePos:Control
var levelNode:Control

var originalPosXMoney

var frequencyWavePrice:ValueSaver = ValueSaver.new()

var centerYdef = 53.0
var centerYdefLevel = 28.0

var priceLevelYdef = 87.0
var levelMaxYdef = 53.0

func _ready() -> void:
	frequencyWavePrice.number = 0
	originalPosXMoney = get_node("Holder/Prce").position.x
	moneyNode = get_node("Holder/Prce/Price")
	moneyNodePos = get_node("Holder/Prce")
	levelNode = get_node("Holder/Level")
	get_node("Holder/SubViewportContainer/SubViewport/Title").text = shopData.title
	get_node("Holder/ItemImage").texture = shopData.image
	descriptionNode = get_node("Holder/SubViewportContainerDesc/SubViewport/Description")
	descriptionNode.text = shopData.description
	ModifyTexts()
	CustomItemText()
	SetBasedOnLevel()
	RandomGradient()
	pass # Replace with function body.

func RandomGradient():
	var mat = randomSpeedTitleShade.material.duplicate()
	mat.set_shader_parameter("random_start", randf_range(0.0,1.0))
	randomSpeedTitleShade.material = mat
	var mat2 = randomSpeedDescriptionShade.material.duplicate()
	mat2.set_shader_parameter("random_start", randf_range(0.0,1.0))
	randomSpeedDescriptionShade.material = mat2
func CustomItemText(): #godot doesn't support variable inside serialize inspector, so I have to set it manually
	match shopData.power:
		Powers.none:
			pass
		Powers.multiplier:
			descriptionNode.text = "the more you buy it the more the collect doubles (will stay the same multiply even after [rainbow]rebirth[/rainbow])\n"+\
			"Current Main Multiplier:" + str(int(GameHandler.saveDataRebirth.multiplier_reb)) + "X"
		Powers.offer:
			descriptionNode.text = "you will gain offer on every item (except rebirth items)\n"+\
			"Current offer:" + str(int((GameHandler.saveDataRebirth.offer-1) * 100)) + "%"



func SetBasedOnLevel():
	if (shopData.level > 0):
		moneyNodePos.position.y = priceLevelYdef
		moneyNodePos.scale = Vector2(0.8,0.8)
		levelNode.modulate.a = 1
	if (!shopData.canBuy):
		levelNode.position.y = levelMaxYdef
		levelNode.scale = Vector2(1,1)
		moneyNodePos.modulate.a = 0


func set_item(rebirthDat:RebirthClass):
	shopData = rebirthDat

func _process(_delta: float) -> void:
	Hovered()
	Bought()
	moneyNode.text = "[wave amp=%d freq=10]%s[/wave]" % [frequencyWavePrice.number,NumberFormat.Format(shopData.rebirthPrice)]
	pass

func Hovered():
	var mouse_pos = get_global_mouse_position()
	
	if (get_global_rect().has_point(mouse_pos) && !isInside) && !GameHandler.GamePausedPartil():
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(get_node("BG"),170/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1.02,1.02),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),-5,0.2,TweenUtils.Ease.OutCirc)
		isInside = true
	elif (!get_global_rect().has_point(mouse_pos) && isInside) || GameHandler.GamePausedPartil():
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(get_node("BG"),95.0/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1,1),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),0,0.2,TweenUtils.Ease.OutCirc)
		isInside = false

func ModifyTexts():
	#moneyNode.text = "$" + str(shopData.price)
	moneyNode.text = "[wave amp=%d freq=5]%s%d[/wave]" % [frequencyWavePrice.number, "$",shopData.rebirthPrice]
	if (shopData.canBuy):
		levelNode.text = "lv:"+ str(shopData.level)
	else:
		levelNode.text = "lv:Max"
	CustomItemText()

var colorTween:Tween

func TweenColor(col:Color):
	TweenUtils.StopTween(colorTween)
	moneyNode.modulate = col
	colorTween = TweenUtils.tweenColorRGB(moneyNode,Color(1.0, 1.0, 1.0, 1.0),0.3,TweenUtils.Ease.linear)

var colorTweenLevel
func TweenColorLevel(col:Color):
	TweenUtils.StopTween(colorTweenLevel)
	levelNode.modulate = col
	colorTweenLevel = TweenUtils.tweenColorRGB(levelNode,Color(1.0, 1.0, 1.0, 1.0),0.3,TweenUtils.Ease.linear)

var tweenXtext:Tween

func PowersAct():
	match shopData.power:
		Powers.none:
			pass
		Powers.multiplier:
			GameHandler.saveDataRebirth.multiplier_reb += 1
		Powers.offer:
			GameHandler.saveDataRebirth.offer += 0.10
func TweenLevelMax():
	TweenUtils.tweenY(levelNode,centerYdef,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenScale(levelNode,Vector2(1,1),0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenAlpha(moneyNode,0,0.3,TweenUtils.Ease.linear)

var tweenXtextLevel:Tween
func Bought():
	if isInside && Input.is_action_just_pressed("LeftMouse"):
		if (shopData.power == Powers.none):
			push_error("no power added")
			return
		if (!shopData.canBuy):
			TweenColorLevel(Color(1,0,0,1))
			levelNode.position.x = originalPosXMoney - 7
			TweenUtils.StopTween(tweenXtextLevel)
			tweenXtextLevel = TweenUtils.tweenX(levelNode,originalPosXMoney,0.3,TweenUtils.Ease.OutCirc)
			GlobalAudio.PlayOneShot("res://Sounds/negative.mp3",10)
			return
		if (GameHandler.saveDataRebirth.rebirth >= shopData.rebirthPrice):
			PowersAct()
			GameHandler.saveDataRebirth.rebirth -= shopData.rebirthPrice
			shopData.rebirthPrice = int(floor(shopData.rebirthPrice * shopData.tax))
			shopData.tax += shopData.taxInc
			TweenColor(Color(0.0, 0.905, 0.2))
			frequencyWavePrice.number = 40
			TweenUtils.tweenNumber(self,frequencyWavePrice,0,0.2,TweenUtils.Ease.linear)
			if shopData.level == 0:
				TweenUtils.tweenY(moneyNodePos,priceLevelYdef,0.3,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenScale(moneyNodePos,Vector2(0.8,0.8),0.3,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenAlpha(levelNode,1,0.3,TweenUtils.Ease.linear)
			shopData.level += 1
			ModifyTexts()
			#ResourceUtil.SaveResource(GameHandler.saveData,"ShopList.tres","saver")
			var partic = InstantiateUtil.Instantiate(particle,get_tree().get_first_node_in_group("UI"))
			partic.global_position = get_node("Holder/ParticlePlace").global_position
			GlobalAudio.PlayOneShot("res://Sounds/bought.mp3",4)
			GlobalAudio.PlayOneShot("res://Sounds/party_popper.mp3",4)
			GlobalAudio.PlayOneShot("res://Sounds/party_sound.mp3",4)
			GameHandler.SaveAllDataGlob()
			#ResourceSaver.save(GameHandler.shopListGlob,"res://saver/ShopList.tres") # save shop list
		else:
			moneyNodePos.position.x = originalPosXMoney - 7
			TweenUtils.StopTween(tweenXtext)
			tweenXtext = TweenUtils.tweenX(moneyNodePos,originalPosXMoney,0.3,TweenUtils.Ease.OutCirc)
			TweenColor(Color(1.0, 0.0, 0.0))
			GlobalAudio.PlayOneShot("res://Sounds/negative.mp3",10)
