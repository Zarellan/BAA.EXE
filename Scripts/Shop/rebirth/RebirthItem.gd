extends Control
class_name RebirthItem

static var rebirthItems:Dictionary[String, RebirthItem]

enum Powers{
	none,
	multiplier,
	offer,
	jumpPower,
	autoCollect,
	goldWoolMultiply,
	rainbowWool,
	rainbowWoolMultiply,
	cheaperRebirth,
	stomp
}

@export var particle:PackedScene

@export var shopData:RebirthClass

@export var randomSpeedTitleShade:Control
@export var randomSpeedDescriptionShade:Control

@export var rainbowShaderMaterial:Shader
@export var rainbowShaderMaterialMask:Shader

@export var borderGradient:Texture2D

@export var bG:Control
@export var bG2:Control

#tweens
var tweenAlpha:Tween
var tweenHolder:Tween
var tweenRotationImage:Tween

var isInside = false

var descriptionNode:Control
var moneyNode:Control
var moneyNodePos:Control
var levelNode:Control
var itemImage:Control
var originalPosXMoney

var frequencyWavePrice:ValueSaver = ValueSaver.new()

var centerYdef = 53.0
var centerYdefLevel = 28.0

var priceLevelYdef = 87.0
var levelMaxYdef = 53.0

var goldMaterial1:ShaderMaterial
var goldMaterial2:ShaderMaterial

var possibleBought = true

func _ready() -> void:
	frequencyWavePrice.number = 0
	originalPosXMoney = get_node("Holder/Prce").position.x
	moneyNode = get_node("Holder/Prce/Price")
	moneyNodePos = get_node("Holder/Prce")
	levelNode = get_node("Holder/Level")
	get_node("Holder/SubViewportContainer/SubViewport/Title").text = shopData.title
	itemImage = get_node("Holder/ItemImage")
	itemImage.texture = shopData.image
	descriptionNode = get_node("Holder/SubViewportContainerDesc/SubViewport/Description")
	descriptionNode.text = shopData.description
	ModifyTexts()
	CustomItemText()
	SetBasedOnLevel()
	RandomGradient()
	goldMaterial1 = bG.material.duplicate()
	bG.material = goldMaterial1
	goldMaterial2 = bG2.material.duplicate()
	bG2.material = goldMaterial2
	ExceptionalItems()
	ExceptionalLock()
	rebirthItems[shopData.title] = self
	pass # Replace with function body.

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func ExceptionalItems():
	match (shopData.power):
		Powers.rainbowWool, Powers.rainbowWoolMultiply:
			var shadeMater:ShaderMaterial = ShaderMaterial.new()
			shadeMater.shader = rainbowShaderMaterial
			bG.material = shadeMater
			
			bG2.material = shadeMater.duplicate()
			bG2.material.set_shader_parameter("border_only", true)
			
			var shadeMater2:ShaderMaterial = ShaderMaterial.new()
			shadeMater2.shader = rainbowShaderMaterialMask
			get_node("Holder/SubViewportContainer/SubViewport/Title").material = shadeMater2
			get_node("Holder/SubViewportContainerDesc/SubViewport/Description").material = shadeMater2
			get_node("Holder/SubViewportContainer/SubViewport/Title").self_modulate = Color(1.0, 1.0, 1.0, 1.0)
			get_node("Holder/SubViewportContainerDesc/SubViewport/Description").self_modulate = Color(1.0, 1.0, 1.0, 1.0)
			get_node("Holder/SubViewportContainer").material = null
			get_node("Holder/SubViewportContainerDesc").material = null
		Powers.jumpPower , Powers.stomp:
			get_node("BackBufferCopy/GlitchingEffect").visible = true
			bG.material.set_shader_parameter("border_gradient", borderGradient)
			SetUniqueShader((get_node("Holder/SubViewportContainer") as Control))
			(get_node("Holder/SubViewportContainer") as Control).material.set_shader_parameter("gradient",borderGradient)
			SetUniqueShader((get_node("Holder/SubViewportContainerDesc") as Control))
			(get_node("Holder/SubViewportContainerDesc") as Control).material.set_shader_parameter("gradient",Texture2D.new())
			get_node("Holder/SubViewportContainer/SubViewport/Title").self_modulate = Color(1.0, 1.0, 1.0, 1.0)
			get_node("Holder/SubViewportContainerDesc/SubViewport/Description").self_modulate = Color(1.0, 1.0, 1.0, 1.0)
			SetUniqueShader(itemImage)
			itemImage.material = null
			if (shopData.power == Powers.stomp):
				SetUniqueShader(get_node("BackBufferCopy/GlitchingEffect"))
				get_node("BackBufferCopy/GlitchingEffect").material.set_shader_parameter("shake_power",0.0015)

		pass
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

func SetUniqueShader(obj:Control):
	var shade = obj.material.duplicate()
	obj.material = shade

func RandomGradient():
	var mat = randomSpeedTitleShade.material.duplicate()
	mat.set_shader_parameter("random_start", randf_range(0.0,1.0))
	randomSpeedTitleShade.material = mat
	var mat2 = randomSpeedDescriptionShade.material.duplicate()
	mat2.set_shader_parameter("random_start", randf_range(0.0,1.0))
	randomSpeedDescriptionShade.material = mat2

#region Custom Item Text

func CustomItemText():
	match shopData.power:
		Powers.none:
			pass
		Powers.multiplier:
			descriptionNode.text = "the more you buy it the more the collect doubles (will stay the same multiply even after [rainbow]rebirth[/rainbow])\n"+\
			"Current Main Multiplier:" + str(int(GameHandler.saveDataRebirth.multiplier_reb)) + "X"
		Powers.offer:
			descriptionNode.text = "you will gain offer on every item (except rebirth items)\n"+\
			"Current offer:" + str(int((GameHandler.saveDataRebirth.offer-1) * 100)) + "%"
		Powers.jumpPower:
			descriptionNode.text = "will increase the power jump of sheep in plaform minigame by +100\n"+\
			"Current power jump:" + str(GameHandler.TotalJumpPower())

		Powers.autoCollect:
			if (!GameHandler.saveDataRebirth.autoCollectSheepAbility):
				descriptionNode.text = "you will auto collect from [rainbow]sheep himself[/rainbow]\neven after rebirth"
			else:
				descriptionNode.text = "you will auto collect from [rainbow]sheep himself[/rainbow]\neven after rebirth\n"+\
				"super collector total:" + str(float(GameHandler.saveDataRebirth.autoCollectSheep)) + " seconds\n"+\
				"collect every:[rainbow][wave amp=25.0 freq=10.0]" + str(float(GameHandler.AutoCollectSheepTotalParse())) + "[/wave] seconds"
		Powers.goldWoolMultiply:
			descriptionNode.text = "on each purchase you will gain gold wool multiplier by [wave amp=25.0 freq=10.0]+5[/wave]\n"+\
			"current gold multiplier:X" + str(GameHandler.GoldWoolMultiplierTotal())
		Powers.rainbowWool:
			descriptionNode.text = "the chance of appereance will increase by [wave amp=25.0 freq=10.0]+1%[/wave]\n"+\
			"Current Rainbow wool chance:" + str(GameHandler.saveDataRebirth.rainbowWoolChance * 100) + "%"
		Powers.rainbowWoolMultiply:
			if (GameHandler.saveDataRebirth.rainbowWoolChance <= 0.0):
				descriptionNode.text = "on each purchase you will gain rainbow wool multiplier by +100\n"+\
				"[color=red]purchasing [wave amp=25.0 freq=10.0][color=green]Rainbow wool[/color][/wave][color=red] is recommended first"
			else:
				descriptionNode.text = "on each purchase you will gain rainbow wool multiplier by +100\n"+\
				"current rainbow multiplier:X" + str(GameHandler.RainbowWoolMultiplierTotal())
		Powers.cheaperRebirth:
				descriptionNode.text = "the rebirth system will be cheaper on every purchase\n"+\
				"current required rebirth:" + str(NumberFormat.Format(RebirthMenu.base_rebirth_total))

#endregion

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
	CustomItemText()
	moneyNode.text = "[wave amp=%d freq=10]%s[/wave]" % [frequencyWavePrice.number,NumberFormat.Format(shopData.rebirthPrice)]
	pass

func ExceptionalLock():
	match (shopData.power):
		Powers.rainbowWoolMultiply:
			possibleBought = false
			if GameHandler.saveDataRebirth.rainbowWoolChance > 0.01 || is_equal_approx(GameHandler.saveDataRebirth.rainbowWoolChance, 0.01):
				possibleBought = true
	if (!possibleBought):
		get_node("Holder/Lock").self_modulate.a = 1
		moneyNodePos.modulate.a = 0
	else:
		get_node("Holder/Lock").self_modulate.a = 0
		moneyNodePos.modulate.a = 1

func BoughtUnlock():
	match (shopData.power):
		Powers.rainbowWool:
			if (!rebirthItems["Rainbow wool multiplier"].possibleBought):
				rebirthItems["Rainbow wool multiplier"].Unlock()

func Unlock():
	TweenUtils.tweenAlphaSelf(get_node("Holder/Lock"),0,0.3,TweenUtils.Ease.linear)
	TweenUtils.tweenAlpha(moneyNodePos,1,0.3,TweenUtils.Ease.linear)
	possibleBought = true

func Hovered():
	var mouse_pos = get_global_mouse_position()
	
	if (get_global_rect().has_point(mouse_pos) && !isInside) && !GameHandler.GamePausedPartil():
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(bG,170/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenHolder = TweenUtils.tweenScale(get_node("Holder"),Vector2(1.02,1.02),0.2,TweenUtils.Ease.OutCirc)
		tweenRotationImage = TweenUtils.tweenRotation(get_node("Holder/ItemImage"),-5,0.2,TweenUtils.Ease.OutCirc)
		isInside = true
	elif (!get_global_rect().has_point(mouse_pos) && isInside) || GameHandler.GamePausedPartil():
		TweenUtils.StopTween(tweenAlpha)
		TweenUtils.StopTween(tweenHolder)
		TweenUtils.StopTween(tweenRotationImage)
		tweenAlpha = TweenUtils.tweenAlpha(bG,95.0/255.0,0.2,TweenUtils.Ease.OutCirc)
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

var colorTweenLock:Tween
func TweenColorLock(col:Color):
	TweenUtils.StopTween(colorTweenLock)
	get_node("Holder/Lock").self_modulate = col
	colorTweenLock = TweenUtils.tweenColorRGBself(get_node("Holder/Lock"),Color(1.0, 1.0, 1.0, 1.0),0.3,TweenUtils.Ease.linear)

var tweenXtext:Tween

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func PowersAct(): #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	match shopData.power:
		Powers.none:
			pass
		Powers.multiplier:
			GameHandler.saveDataRebirth.multiplier_reb += 1
		Powers.offer:
			GameHandler.saveDataRebirth.offer += 0.10
		Powers.jumpPower:
			GameHandler.saveDataRebirth.powerJump += 100
			if (GameHandler.saveDataRebirth.powerJump > 1500 || is_equal_approx(GameHandler.saveDataRebirth.powerJump,1000)):
				TweenLevelMax()
				shopData.canBuy = false
		Powers.autoCollect:
			GameHandler.saveDataRebirth.autoCollectSheep -= 0.15
			if (!GameHandler.saveDataRebirth.autoCollectSheepAbility):
				GameHandler.saveDataRebirth.autoCollectSheepAbility = true
			if (GameHandler.saveDataRebirth.autoCollectSheep < (0.15 - 3) || is_equal_approx(GameHandler.saveDataRebirth.autoCollectSheep, (0.15 - 3))):
				GameHandler.saveDataRebirth.autoCollectSheep = 0.15 - 3
				TweenLevelMax()
				shopData.canBuy = false
		Powers.goldWoolMultiply:
			GameHandler.saveDataRebirth.goldWoolMultiplier += 5
		Powers.rainbowWool:
			GameHandler.saveDataRebirth.rainbowWoolChance += 0.01
			if (GameHandler.saveDataRebirth.rainbowWoolChance >= 0.70):
				TweenLevelMax()
				shopData.canBuy = false
		Powers.rainbowWoolMultiply:
			GameHandler.saveDataRebirth.rainbowWoolMultiplier += 100
		Powers.cheaperRebirth:
			GameHandler.saveDataRebirth.cheaperRebirth += 0.10
		Powers.cheaperRebirth:
			GameHandler.saveDataRebirth.powerStomp = true
			TweenLevelMax()
			shopData.canBuy = false

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

func TweenLevelMax():
	TweenUtils.tweenY(levelNode,centerYdef,0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenScale(levelNode,Vector2(1,1),0.3,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenAlpha(get_node("Holder/Prce"),0,0.3,TweenUtils.Ease.linear)

var tweenXtextLevel:Tween
var tweenXLock:Tween

func Bought():
	if isInside && Input.is_action_just_pressed("LeftMouse"):
		if (shopData.power == Powers.none):
			push_error("no power added")
			return
		if (!possibleBought):
			get_node("Holder/Lock").position.x = 70.0 - 10
			TweenColorLock(Color(1,0,0,1))
			TweenUtils.StopTween(tweenXLock)
			tweenXLock = TweenUtils.tweenX(get_node("Holder/Lock"),70,0.3,TweenUtils.Ease.OutCirc)
			ToShine()
			return
		if (!shopData.canBuy):
			TweenColorLevel(Color(1,0,0,1))
			levelNode.position.x = 10 - 7
			TweenUtils.StopTween(tweenXtextLevel)
			tweenXtextLevel = TweenUtils.tweenX(levelNode,10,0.3,TweenUtils.Ease.OutCirc)
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
			GlobalAudio.PlayOneShot("res://Sounds/bought.mp3",-2)
			GlobalAudio.PlayOneShot("res://Sounds/party_popper.mp3",5)
			GlobalAudio.PlayOneShot("res://Sounds/party_sound.mp3",5)
			GlobalAudio.PlayOneShot("res://Sounds/RebirthBought.mp3",3)
			GoldBGShaderTween()
			BoughtUnlock()
			GameHandler.SaveAllDataGlob()
			#ResourceSaver.save(GameHandler.shopListGlob,"res://saver/ShopList.tres") # save shop list
		else:
			moneyNodePos.position.x = originalPosXMoney - 7
			TweenUtils.StopTween(tweenXtext)
			tweenXtext = TweenUtils.tweenX(moneyNodePos,originalPosXMoney,0.3,TweenUtils.Ease.OutCirc)
			TweenColor(Color(1.0, 0.0, 0.0))
			GlobalAudio.PlayOneShot("res://Sounds/negative.mp3",10)


func ToShine():
	match (shopData.power):
		Powers.rainbowWoolMultiply:
			rebirthItems["Rainbow wool"].Shine()

var tweenGold:Tween
var tweenColorBG:Tween
var tweenColorBG2:Tween

var twShine:Tween
func Shine():
	TweenUtils.StopTween(tweenAlpha)
	tweenAlpha = TweenUtils.tweenAlpha(bG,170/255.0,0.2,TweenUtils.Ease.OutCirc)
	tweenAlpha.finished.connect(ShineSignal)

func ShineSignal():
	tweenAlpha = TweenUtils.tweenAlpha(bG,95.0/255.0,0.2,TweenUtils.Ease.OutCirc)
	tweenAlpha.finished.connect(func():
		tweenAlpha = TweenUtils.tweenAlpha(bG,170/255.0,0.2,TweenUtils.Ease.OutCirc)
		tweenAlpha.finished.connect(func():
			tweenAlpha = TweenUtils.tweenAlpha(bG,95.0/255.0,0.2,TweenUtils.Ease.OutCirc))
		)

func GoldBGShaderTween():
	TweenUtils.StopTween(tweenGold)
	tweenGold = TweenUtils.tweenCustom(self, 7.0, 2.584, 0.3, TweenUtils.Ease.OutCirc, func(val): 
		bG.material.set_shader_parameter("border_px", val)
		bG2.material.set_shader_parameter("border_px", val)
	)
	ModifyColorRGB(bG,Color(1.0, 1.0, 0.0))
	ModifyColorRGB(bG2,Color(1.0, 1.0, 0.0))
	TweenUtils.StopTween(tweenColorBG)
	TweenUtils.StopTween(tweenColorBG2)
	tweenColorBG = TweenUtils.tweenColorRGB(bG,Color(1,1,1),0.3,TweenUtils.Ease.OutCirc)
	tweenColorBG2 = TweenUtils.tweenColorRGB(bG2,Color(1,1,1),0.3,TweenUtils.Ease.OutCirc)

func ModifyColorRGB(node,color:Color):
	node.modulate.r = color.r
	node.modulate.g = color.g
	node.modulate.b = color.b
