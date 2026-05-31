extends Control
class_name SettingsScript
static var settings = false


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

var tweenSettings:Tween

var audioText:Control
var soundtrackText:Control
#@export var audioText:AutoSizeRichTextLabel
#@export var soundtrackText:AutoSizeRichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings = false
	audioText = get_node("Volume/AudioVolume")
	soundtrackText = get_node("Volume/SoundtrackVolume")
	(get_node("Volume/SoundtrackSlider") as HSlider).value = GameHandler.saveData.soundtrackVolume
	(get_node("Volume/AudioSlider") as HSlider).value = GameHandler.saveData.audioVolume
	(get_node("Performance/QualityOptions") as OptionButton).select(BasedOnQuality())
	(get_node("Performance/FPSOption") as OptionButton).select(BasedOnFPS())
	(get_node("Performance/VSyncBox") as CheckBox).button_pressed = GameHandler.saveData.vSync
	
	codeText.add_theme_color_override("font_placeholder_color", Color(0.658, 0.658, 0.658, 1.0))
	InitializeSettings()

	pass # Replace with function body.

func InitializeSettings():
	Engine.max_fps = GameHandler.saveData.fps
	SetVSync()
	_on_quality_option_item_selected.call_deferred(BasedOnQuality())
	ChangeSetting(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") && settings:
		(pauseMenu as PauseScript).BringPauseFromSettings()
		ExitSettings()
	if (Input.is_action_just_pressed("Key_Q") && settings):
		ExitSettings()
	if Input.is_action_just_pressed("Enter_Key") && indexSettings == 2:
		CodeRewards()
	pass

func CodeRewards():
	match(codeText.text.to_lower()):
		"eid mubarak":
			if (!CodeDoublecheck("eid mubarak")):
				codeTextSub.text = "Eid Mubarak you too [font_size=50]🥳"
				GameHandler.AddMoneyForce(10000)
				get_tree().get_first_node_in_group("Sheep").BringEidCap()
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

func ChangeSetting(index:int):
	indexSettings += index
	IndexRangeLimit(settingOptions)
	for i in range(settingOptions.size()):
		if (i != indexSettings):
			settingOptions[i].visible = false
		else:
			settingOptions[i].visible = true
			settingText.text = settingOptions[i].name
			
func IndexRangeLimit(indexMax:Array):
	if (indexMax.size() - 1 < indexSettings):
		indexSettings = 0
	elif (indexSettings < 0):
		indexSettings = indexMax.size() - 1
func BringSettings():
	if !settings:
		TweenUtils.StopTween(tweenSettings)
		tweenSettings = TweenUtils.tweenY(self,0.0,0.3,TweenUtils.Ease.OutCirc)
		(get_node("Volume/SoundtrackSlider") as HSlider).value = GameHandler.saveData.soundtrackVolume
		(get_node("Volume/AudioSlider") as HSlider).value = GameHandler.saveData.audioVolume
		ChangeText()
		settings = true

func ExitSettings():
	if settings:
		TweenUtils.StopTween(tweenSettings)
		tweenSettings = TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		settings = false


func _on_h_slider_value_changed(value: float) -> void:
	GameHandler.saveData.soundtrackVolume = value
	GlobalSoundtrack.ChangeVolumeSettings()
	ChangeText()
	pass # Replace with function body.audioVolume


func _on_audio_slider_value_changed(value: float) -> void:
	GameHandler.saveData.audioVolume = value
	ChangeText()
	pass # Replace with function body.


func _on_back_pressed() -> void:
	(pauseMenu as PauseScript).BringPauseFromSettings()
	ExitSettings()
	pass # Replace with function body.

func ChangeText():
	(audioText as AutoSizeRichTextLabel).text = "Audio Volume:"+str(GameHandler.saveData.audioVolume) +"%"
	(soundtrackText as AutoSizeRichTextLabel).text = "Track Volume:"+str(GameHandler.saveData.soundtrackVolume) +"%"
	pass


func _on_arrow_button_left_pressed() -> void:
	ChangeSetting(-1)
	pass # Replace with function body.


func _on_arrow_button_right_pressed() -> void:
	ChangeSetting(1)
	pass # Replace with function body.


func _on_quality_option_item_selected(index: int) -> void:
	match(index):
		0:
			GameHandler.saveData.quality = GameHandler.Quality.High
			shadedGrassNode.visible = true
		1:
			GameHandler.saveData.quality = GameHandler.Quality.Low
			shadedGrassNode.visible = false
	var starSpawner = get_tree().get_first_node_in_group("StarSpawner")
	(starSpawner as StarSpawner).SpawnStars()
	pass # Replace with function body.

func BasedOnQuality():
	match(GameHandler.saveData.quality):
		GameHandler.Quality.High:
			return 0
		GameHandler.Quality.Low:
			return 1
	pass


func _on_fps_option_item_selected(index: int) -> void:
	match (index):
		0: GameHandler.saveData.fps = 30
		1: GameHandler.saveData.fps = 60
		2: GameHandler.saveData.fps = 120
		3: GameHandler.saveData.fps = 0
	Engine.max_fps = GameHandler.saveData.fps
	pass # Replace with function body.

func BasedOnFPS():
	match (GameHandler.saveData.fps):
		30: 
			return 0
		60: 
			return 1
		120: 
			return 2
		0: 
			return 3

func SetVSync():
	if (GameHandler.saveData.vSync):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_v_sync_box_toggled(toggled_on: bool) -> void:
	GameHandler.saveData.vSync = toggled_on
	SetVSync()
	pass # Replace with function body.


func _on_code_submit_pressed() -> void:
	CodeRewards()
	pass # Replace with function body.


func _on_code_text_timer_timeout() -> void:
	TweenUtils.tweenAlpha(codeTextMain,0,2,TweenUtils.Ease.linear)
	pass # Replace with function body.


func _on_invalid_code_timer_timeout() -> void:
	codeText.placeholder_text = "Code"
	codeText.add_theme_color_override("font_placeholder_color", Color(0.658, 0.658, 0.658, 1.0))
	pass # Replace with function body.


func _on_delete_data_pressed() -> void:
	ResourceUtil.RemoveResources("SaveData","saver")
	GameHandler.saveData = GameSaveData.new()
	ResourceUtil.RemoveResources("SaveDataRebirth","saver")
	GameHandler.saveDataRebirth = GameSaveRebirth.new()
	TransitionScript.ChangeScene("res://Scenes/MainFarm.tscn")
	pass # Replace with function body.
