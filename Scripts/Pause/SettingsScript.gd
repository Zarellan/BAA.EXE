extends Control
class_name SettingsScript
static var settings = false

@export var natureAudio:AudioStreamPlayer
@export var natureDB:float
var indexSettings = 0
@export var settingText:Control
@export var pauseMenu:Control
@export var settingOptions:Array[Control] = []

@export var shadedGrassNode:Node2D
@export var codeText:LineEdit
@export var particle:PackedScene

@export var codeTextMain:Control
@export var codeTextSub:Control
@export var codeTextTimer:Timer
@export var codeInvalidTimer:Timer

@export var colorPicker:ColorPickerButton

var tweenSettings:Tween

var audioText:Control
var soundtrackText:Control
@export var natureText:Control

static var isCode:bool = false

var init = false
var tempAudio:float = 0
func _ready() -> void:
	init = false
	settings = false
	SetCodeMode(false)
	audioText = get_node("Volume/AudioVolume")
	soundtrackText = get_node("Volume/SoundtrackVolume")
	(get_node("Volume/AudioSlider") as HSlider).value = GameHandler.saveDataSettings.audioVolume
	(get_node("Volume/SoundtrackSlider") as HSlider).value = GameHandler.saveDataSettings.soundtrackVolume
	(get_node("Volume/NaturalSlider") as HSlider).value = GameHandler.saveDataSettings.natureVolume
	(get_node("Performance/QualityOptions") as OptionButton).select(BasedOnQuality())
	(get_node("Performance/FPSOption") as OptionButton).select(BasedOnFPS())
	get_node("Performance-2/UpdateIntervalsText").text = "Update Intervals:%.2f" % GameHandler.saveDataSettings.updateInterval
	(get_node("Performance/VSyncBox") as CheckBox).button_pressed = GameHandler.saveDataSettings.vSync
	(get_node("Effects/GlitchEffectBox") as CheckBox).button_pressed = GameHandler.saveDataSettings.glitchEffect
	(get_node("Effects/BorderShadeBox") as CheckBox).button_pressed = GameHandler.saveDataSettings.shadingBorders
	codeText.add_theme_color_override("font_placeholder_color", Color(0.658, 0.658, 0.658, 1.0))
	InitializeSettings()
	get_tree().get_first_node_in_group("Sheep").get_node("StaticBody2D/Sprite2D").material.set_shader_parameter("replace_color", GameHandler.saveDataSettings.sheepColor)
	colorPicker.color = GameHandler.saveDataSettings.sheepColor
	visible = false
	await RenderingServer.frame_post_draw
	(func():
		(func():
			init = true).call_deferred()).call_deferred()
	pass # Replace with function body.

func InitializeSettings():
	Engine.max_fps = GameHandler.saveDataSettings.fps
	SetVSync()
	_on_border_shade_box_toggled.call_deferred(GameHandler.saveDataSettings.shadingBorders)
	_on_quality_option_item_selected.call_deferred(BasedOnQuality())
	ChangeSetting(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") && settings:
		(pauseMenu as PauseScript).BringPauseFromSettings()
		ExitSettings()
	#if (GameHandler.KeysWhenExit([]) && settings):
		#ExitSettings()
	if Input.is_action_just_pressed("Enter_Key") && indexSettings == 2:
		CodeRewards()
	pass

func CodeRewards():
	match(codeText.text.to_lower()):
		"eid mubarak":
			if (!CodeDoublecheck("eid mubarak")):
				codeTextSub.text = "Eid Mubarak you too [font_size=50][img]res://Sprites/emojies/Party.png[/img]"
				GameHandler.AddMoneyForce(3000)
				#get_tree().get_first_node_in_group("Sheep").BringEidCap()
				GameHandler.UnlockSkin("Eid")
		_:
			codeText.placeholder_text = "Invalid code"
			CodeInvalid("Invalid code")

func CodeInvalid(_str):
	codeText.placeholder_text = _str
	codeText.text = ""
	codeText.add_theme_color_override("font_placeholder_color", Color(1, 0, 0))
	GlobalAudio.PlayOneShot("res://Sounds/negative.mp3",10)
	codeInvalidTimer.start()

func CodeDoublecheck(_str):
	for i in range(GameHandler.saveData.checkCodes.size()):
		if (_str == GameHandler.saveData.checkCodes[i][0]):
			if (GameHandler.saveData.checkCodes[i][1]):
				CodeInvalid("Already used")
				return true
			else:
				GameHandler.saveData.checkCodes[i][1] = true
				var partic = InstantiateUtil.Instantiate(particle,get_tree().get_first_node_in_group("UI"))
				partic.global_position = get_node("Code/ParticlePosition").global_position
				self.scale = Vector2(1.3,0.9)
				GlobalAudio.PlayOneShot("res://Sounds/bought.mp3",4)
				GlobalAudio.PlayOneShot("res://Sounds/party_popper.mp3",4)
				GlobalAudio.PlayOneShot("res://Sounds/party_sound.mp3",4)
				TweenUtils.tweenScale(self,Vector2(1,1),0.3,TweenUtils.Ease.OutCirc)
				codeTextMain.modulate.a = 1
				codeTextTimer.start()
				return false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.unicode != 0:
		var asc = event.unicode
		if (isCode && ((asc >= 97 and asc <= 122) or (asc >= 65 and asc <= 90))):
			codeText.text += char(asc)
	if event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_BACKSPACE && isCode:
			codeText.text = codeText.text.left(-1)
		elif event.physical_keycode == KEY_SPACE && isCode:
			codeText.text += ' '
func ChangeSetting(index:int):
	indexSettings += index
	IndexRangeLimit(settingOptions)
	for i in range(settingOptions.size()):
		if (i != indexSettings):
			settingOptions[i].visible = false
		else:
			settingOptions[i].visible = true
			settingText.text = settingOptions[i].name
			if (settingOptions[i].name == "Code"):
				SetCodeMode(true)
			else:
				SetCodeMode(false)

func SetCodeMode(tog:bool):
	isCode = tog
	if (tog):
		get_node("Code/CodeSubmit").focus_mode = FocusMode.FOCUS_NONE
		get_node("ArrowButtonLeft").focus_mode = FocusMode.FOCUS_NONE
		get_node("ArrowButtonRight").focus_mode = FocusMode.FOCUS_NONE
		get_node("Back").focus_mode = FocusMode.FOCUS_NONE
	else:
		get_node("Code/CodeSubmit").focus_mode = FocusMode.FOCUS_ALL
		get_node("ArrowButtonLeft").focus_mode = FocusMode.FOCUS_ALL
		get_node("ArrowButtonRight").focus_mode = FocusMode.FOCUS_ALL
		get_node("Back").focus_mode = FocusMode.FOCUS_ALL
		#$Code/CodeSubmit.focus_mode = FocusMode.FOCUS_NONE
func IndexRangeLimit(indexMax:Array):
	if (indexMax.size() - 1 < indexSettings):
		indexSettings = 0
	elif (indexSettings < 0):
		indexSettings = indexMax.size() - 1
func BringSettings():
	if !settings:
		TweenUtils.StopTween(tweenSettings)
		tweenSettings = TweenUtils.tweenY(self,0.0,0.3,TweenUtils.Ease.OutCirc)
		(get_node("Volume/SoundtrackSlider") as HSlider).value = GameHandler.saveDataSettings.soundtrackVolume
		(get_node("Volume/AudioSlider") as HSlider).value = GameHandler.saveDataSettings.audioVolume
		ChangeText()
		settings = true
		if (indexSettings == 2):
			SetCodeMode(true)
		visible = true

func ExitSettings():
	if settings:
		TweenUtils.StopTween(tweenSettings)
		tweenSettings = TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		tweenSettings.finished.connect(func():
			visible = false)
		settings = false
		SetCodeMode(false)
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))


func _on_h_slider_value_changed(value: float) -> void:
	GameHandler.saveDataSettings.soundtrackVolume = value
	GlobalSoundtrack.ChangeVolumeSettings()
	ChangeText()
	pass # Replace with function body.audioVolume


func _on_audio_slider_value_changed(value: float) -> void:
	GameHandler.saveDataSettings.audioVolume = value
	ChangeText()
	pass # Replace with function body.

func _on_natural_slider_value_changed(value: float) -> void:
	GameHandler.saveDataSettings.natureVolume = value
	natureAudio.volume_db = VolumeSettings(natureDB)
	ChangeText()
	pass # Replace with function body.
	
func VolumeSettings(volumeDB):
	var soundVol = clamp(GameHandler.saveDataSettings.natureVolume,0,100)
	
	if (soundVol == 0):
		return -80
	else:
		return volumeDB + 20.0 * log10M(soundVol/100.0)

func log10M(value):
	return log(value) / log(10)

func _on_back_pressed() -> void:
	(pauseMenu as PauseScript).BringPauseFromSettings()
	ExitSettings()
	pass # Replace with function body.

func ChangeText():
	(audioText as AutoSizeRichTextLabel).text = "Audio Volume:"+str(GameHandler.saveDataSettings.audioVolume) +"%"
	(soundtrackText as AutoSizeRichTextLabel).text = "Track Volume:"+str(GameHandler.saveDataSettings.soundtrackVolume) +"%"
	(natureText as AutoSizeRichTextLabel).text = "Nature Volume:"+str(GameHandler.saveDataSettings.natureVolume) +"%"
	pass


func _on_arrow_button_left_pressed() -> void:
	ChangeSetting(-1)
	if (init):
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_arrow_button_right_pressed() -> void:
	ChangeSetting(1)
	if (init):
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_quality_option_item_selected(index: int) -> void:
	match(index):
		0:
			GameHandler.saveDataSettings.quality = GameHandler.Quality.High
			shadedGrassNode.visible = true
		1:
			GameHandler.saveDataSettings.quality = GameHandler.Quality.Low
			shadedGrassNode.visible = false
		2:
			GameHandler.saveDataSettings.quality = GameHandler.Quality.TooLow
			shadedGrassNode.visible = false
	await RenderingServer.frame_post_draw #StarSpawner won't load in first frame reload so waiting is the solution
	var starSpawner = get_tree().get_first_node_in_group("StarSpawner")
	(starSpawner as StarSpawner).SpawnStars.call_deferred()
	var grasses = get_tree().get_nodes_in_group("Grass")
	for i in range(grasses.size()):
		grasses[i].SetGrassBasedQuality()
	SetGrassDark(shadedGrassNode.visible)
	pass

func SetGrassDark(vis:bool = true):
	var grassDarks:Array[Node] = get_tree().get_nodes_in_group("GrassDark")
	for i in range(grassDarks.size()):
		grassDarks[i].visible = vis
func BasedOnQuality():
	match(GameHandler.saveDataSettings.quality):
		GameHandler.Quality.High:
			return 0
		GameHandler.Quality.Low:
			return 1
		GameHandler.Quality.TooLow:
			return 2
	pass


func _on_fps_option_item_selected(index: int) -> void:
	match (index):
		0:GameHandler.saveDataSettings.fps = 24
		1: GameHandler.saveDataSettings.fps = 30
		2: GameHandler.saveDataSettings.fps = 60
		3: GameHandler.saveDataSettings.fps = 120
		4: GameHandler.saveDataSettings.fps = 0
	Engine.max_fps = GameHandler.saveDataSettings.fps
	print(Engine.max_fps)
	pass # Replace with function body.

func BasedOnFPS():
	match (GameHandler.saveDataSettings.fps):
		24: 
			return 0
		30: 
			return 1
		60: 
			return 2
		120: 
			return 3
		0:
			return 4

func SetVSync():
	if (GameHandler.saveDataSettings.vSync):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_v_sync_box_toggled(toggled_on: bool) -> void:
	GameHandler.saveDataSettings.vSync = toggled_on
	SetVSync()
	if (init):
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_code_submit_pressed() -> void:
	CodeRewards()
	if (init):
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_code_text_timer_timeout() -> void:
	TweenUtils.tweenAlpha(codeTextMain,0,2,TweenUtils.Ease.linear)
	pass # Replace with function body.


func _on_invalid_code_timer_timeout() -> void:
	codeText.placeholder_text = "Code"
	codeText.add_theme_color_override("font_placeholder_color", Color(0.658, 0.658, 0.658, 1.0))
	pass # Replace with function body.


func _on_delete_data_pressed() -> void:
	TransitionScript.ChangeScene("res://Scenes/MainFarm.tscn",DeleteData)
	pass # Replace with function body.

func DeleteData():
	GameHandler.ResetData()
	GameHandler.StaticReset()


func _on_glitch_effect_box_toggled(toggled_on: bool) -> void:
	await RenderingServer.frame_post_draw
	var keys = ShopItem.shopItems.keys()
	var keysRebirth = RebirthItem.rebirthItems.keys()
	GameHandler.saveDataSettings.glitchEffect = toggled_on
	for i in range(keys.size()):
		ShopItem.shopItems[keys[i]].GlitchApply()
	for i in range(keysRebirth.size()):
		RebirthItem.rebirthItems[keysRebirth[i]].GlitchApply()
	if (init):
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_color_picker_button_color_changed(color: Color) -> void:
	colorPicker.color = Color(color.r,color.g,color.b,1.0)
	GameHandler.saveDataSettings.sheepColor = colorPicker.color
	get_tree().get_first_node_in_group("Sheep").get_node("StaticBody2D/Sprite2D").material.set_shader_parameter("replace_color", GameHandler.saveDataSettings.sheepColor)
	pass # Replace with function body.


func _on_border_shade_box_pressed() -> void:
	pass


func _on_border_shade_box_toggled(toggled_on: bool) -> void:
	await RenderingServer.frame_post_draw
	var keysRebirth = RebirthItem.rebirthItems.keys()
	GameHandler.saveDataSettings.shadingBorders = toggled_on
	for i in range(keysRebirth.size()):
		RebirthItem.rebirthItems[keysRebirth[i]].SetShader(GameHandler.saveDataSettings.shadingBorders)
	get_tree().get_first_node_in_group("RebirthMenu").SetShader(GameHandler.saveDataSettings.shadingBorders)
	get_tree().get_first_node_in_group("OptionUI").SetShader(GameHandler.saveDataSettings.shadingBorders)
	if (init):
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_update_intervals_slider_value_changed(value: float) -> void:
	if (value <= 0.07 && value >= 0.03):
		GameHandler.saveDataSettings.updateInterval = 0.05
	else:
		GameHandler.saveDataSettings.updateInterval = value
	get_node("Performance-2/UpdateIntervalsText").text = "Update Intervals:%.2f" % GameHandler.saveDataSettings.updateInterval
	pass # Replace with function body.
