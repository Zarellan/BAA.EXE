extends Control
class_name ShopItem

static var shopItems:Dictionary[String, ShopItem]

enum Powers{
	none,
	powerClick,
	autoCollect,
	fasterAutoCollector,
	rareClick,
	doubleClick,
	autoCollectSheep, #this was suppose to be replaced with autoCollect but it's too late (maybe in update)
	jumpPower,
	airAccel
}

@export var particle:PackedScene

@export var shopData:ShopClass

#tweens
var tweenAlpha:Tween
var tweenHolder:Tween
var tweenRotationImage:Tween

var isInside = false


var originalPosXMoney

@export var coins: int = 0

@export var title:Control
@export var descriptionNode:Control
@export var textureImage:Control
@export var moneyNode:Control
@export var levelNode:Control
@export var glitchNode:Control

var centerYdef = 53.0
var centerYdefLevel = 28.0

var priceLevelYdef = 87.0
var levelMaxYdef = 53.0

func _ready() -> void:
	originalPosXMoney = get_node("Holder/Price").position.x
	title.text = shopData.title
	textureImage.texture = shopData.image
	descriptionNode.text = shopData.description
	ModifyTexts()
	CustomItemText()
	SetBasedOnLevel()
	ExceptionalItems()
	shopItems[shopData.title] = self
	pass # Replace with function body.

func GlitchApply():
	ExceptionalItems()
func TotalPrice():
	return int(shopData.price / GameHandler.saveDataRebirth.offer)
	
#region Custom Item Text

func CustomItemText():
	match shopData.power:
		Powers.fasterAutoCollector:
			descriptionNode.text = "the collector will gain every [wave amp=25.0 freq=10.0]"\
			+ str(GameHandler.saveData.collectSpeed) + "[/wave] seconds"
		Powers.rareClick:
			descriptionNode.text = "the chance of appereance will increase by [wave amp=25.0 freq=10.0]+1%[/wave]\n"+\
			"Current rare wool chance:[colorT speed=3 sColor=#FFFFFF eColor=#F5BF03]" + str(int(GameHandler.saveData.rareChance * 100)) + "%"
		Powers.doubleClick:
			descriptionNode.text = "the collection will doubles on each purchase\n"+\
			"Current Multiplier:[rainbow]" + str(int(GameHandler.saveData.clickMultiply)) + "X"
		Powers.autoCollectSheep:
			if (!GameHandler.AutoCollectSheepActive()):
				descriptionNode.text = "you will auto collect from [rainbow]sheep himself[/rainbow]"
			else:
				descriptionNode.text = "you will auto collect from [rainbow]sheep himself[/rainbow]\n"+\
				"collect every:[rainbow]" + str(float(GameHandler.AutoCollectSheepTotalParse())) + " seconds"
		Powers.jumpPower:
			descriptionNode.text = "will increase the power jump of sheep in plaform minigame by +25\n"+\
			"Current power jump:" + str(GameHandler.TotalJumpPower())
		Powers.airAccel:
			descriptionNode.text = "will increase the air acceleration of sheep in plaform minigame by +50\n(you can move the sheep left or right while jumping)\n"+\
			"Current acceleration power:" + str(GameHandler.TotalAirAcceleration())

#endregion

#region Exceptional Items
func ExceptionalItems():
	match (shopData.power):
		Powers.airAccel, Powers.jumpPower:
			if (!GameHandler.saveDataSettings.glitchEffect):
				glitchNode.visible = false
				return
			glitchNode.visible = true
			if (shopData.power == Powers.airAccel):
				SetUniqueShader(glitchNode)
				glitchNode.material.set_shader_parameter("shake_power",0.0011)

		pass

#endregion
func SetUniqueShader(obj:Control):
	var shade = obj.material.duplicate()
	obj.material = shade


func SetBasedOnLevel():
	if (shopData.level > 0):
		moneyNode.position.y = priceLevelYdef
		moneyNode.scale = Vector2(0.8,0.8)
		levelNode.modulate.a = 1
	if (!shopData.canBuy):
		levelNode.position.y = levelMaxYdef
		levelNode.scale = Vector2(1,1)
		moneyNode.modulate.a = 0


func set_item(shopDat:ShopClass):
	shopData = shopDat

var last_time_update:float = 0.0
const UPDATE_INTERVAL:float = 0.10
func _process(_delta: float) -> void:
	if (DeviceCheckerUtil.IsUsingPhone()):
		return
	last_time_update += _delta
	Bought()
	if (last_time_update > UPDATE_INTERVAL):
		Hovered()
		ExceptionalPurchase()
		last_time_update = 0
	pass

func _input(event: InputEvent) -> void:
	if (!DeviceCheckerUtil.IsUsingPhone()):
		return
	if event is InputEventScreenTouch:
		if event.is_pressed():
			# The user just tapped the screen / clicked
			Hovered()
			ExceptionalPurchase()
		elif event.is_released() && ShopHelper.totalSwipe < 50:
			Bought()
			pass

var exceptioned := false
func ExceptionalPurchase():
	match (shopData.power):
		Powers.autoCollectSheep:
			if (GameHandler.AutoCollectSheepTotal() <= 0.30 && !exceptioned):
				TweenLevelMax()
				levelNode.modulate.a = 1
				levelNode.text = "lv:Max"
				shopData.canBuy = false
				exceptioned = true


func Hovered():
	var mouse_pos = get_global_mouse_position()
	
	if (get_global_rect().has_point(mouse_pos) && !isInside) && !GameHandler.GamePausedPartil() && ShopHelper.totalSwipe < 50:
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(get_node("BG"),170/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1.02,1.02),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),-5,0.2,TweenUtils.Ease.OutCirc)
		isInside = true
	elif (!get_global_rect().has_point(mouse_pos) && isInside) || GameHandler.GamePausedPartil() || ShopHelper.totalSwipe >= 50:
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(get_node("BG"),95.0/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1,1),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),0,0.2,TweenUtils.Ease.OutCirc)
		isInside = false

func ModifyTexts():
	#moneyNode.text = "$" + str(shopData.price)
	moneyNode.text = "[wave amp=%d freq=5]%s%s[/wave]" % [0, "$",NumberFormat.Format(TotalPrice())]
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

#region Power Act
func PowersAct():
	match shopData.power:
		Powers.powerClick:
			GameHandler.saveData.increment += 2
		Powers.autoCollect:
			GameHandler.saveData.autoCollect += 32
		Powers.fasterAutoCollector:
			GameHandler.saveData.collectSpeed -= 0.30
			if (GameHandler.saveData.collectSpeed <= 1): # custom level max
				TweenLevelMax()
				shopData.canBuy = false
		Powers.rareClick:
			GameHandler.saveData.rareChance += 0.01
			if (GameHandler.saveData.rareChance >= 0.70):
				TweenLevelMax()
				shopData.canBuy = false
		Powers.doubleClick:
			GameHandler.saveData.clickMultiply += 1
		Powers.autoCollectSheep:
			if (!GameHandler.saveData.autoCollectSheepAbility):
				GameHandler.saveData.autoCollectSheepAbility = true
			else:
				GameHandler.saveData.autoCollectSheep -= 0.15
			if (GameHandler.AutoCollectSheepTotal() <= 0.30):
				TweenLevelMax()
				shopData.canBuy = false
		Powers.jumpPower:
			GameHandler.saveData.jumpPower += 25
			if (GameHandler.saveData.jumpPower >= 500):
				TweenLevelMax()
				shopData.canBuy = false
		Powers.airAccel:
			GameHandler.saveData.airAcceleration += 50
			if (GameHandler.saveData.airAcceleration >= 3000):
				TweenLevelMax()
				shopData.canBuy = false

#endregion

func TweenLevelMax():
	TweenUtils.tweenY(levelNode,centerYdef,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenScale(levelNode,Vector2(1,1),0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenAlpha(moneyNode,0,0.3,TweenUtils.Ease.linear)


var tweenXtextLevel:Tween
func Bought():
	if isInside && (Input.is_action_just_pressed("LeftMouse") || DeviceCheckerUtil.IsUsingPhone()):
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
		if (GameHandler.saveData.money >= TotalPrice()):
			PowersAct()
			GameHandler.saveData.money -= TotalPrice() # must set from the origin price
			shopData.price = int(floor(shopData.price * shopData.tax))
			shopData.tax += shopData.taxInc
			TweenColor(Color(0.0, 0.905, 0.2))
			TweenUtils.tweenCustom(self,40,0,0.2,TweenUtils.Ease.linear,func(val):
					moneyNode.text = "[wave amp=%d freq=10]%s%s[/wave]" % [val, "$",NumberFormat.Format(TotalPrice())])
			if shopData.level == 0:
				TweenUtils.tweenY(moneyNode,priceLevelYdef,0.3,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenScale(moneyNode,Vector2(0.8,0.8),0.3,TweenUtils.Ease.OutCirc)
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
			moneyNode.position.x = originalPosXMoney - 7
			TweenUtils.StopTween(tweenXtext)
			tweenXtext = TweenUtils.tweenX(moneyNode,originalPosXMoney,0.3,TweenUtils.Ease.OutCirc)
			TweenColor(Color(1.0, 0.0, 0.0))
			GlobalAudio.PlayOneShot("res://Sounds/negative.mp3",10)
