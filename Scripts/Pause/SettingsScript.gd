extends Control
class_name SettingsScript
static var settings = false

static var soundtrackVolume = 100
static var audioVolume = 100

@export var pauseMenu:Control

var tweenSettings:Tween

var audioText:Control
var soundtrackText:Control
#@export var audioText:AutoSizeRichTextLabel
#@export var soundtrackText:AutoSizeRichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audioText = get_node("AudioVolume")
	soundtrackText = get_node("SoundtrackVolume")
	(get_node("SoundtrackSlider") as HSlider).value = soundtrackVolume
	(get_node("AudioSlider") as HSlider).value = audioVolume

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") && settings:
		(pauseMenu as PauseScript).BringPauseFromSettings()
		ExitSettings()
	pass

func BringSettings():
	if !settings:
		TweenUtils.StopTween(tweenSettings)
		tweenSettings = TweenUtils.tweenY(self,0.0,0.3,TweenUtils.Ease.OutCirc)
		(get_node("SoundtrackSlider") as HSlider).value = soundtrackVolume
		(get_node("AudioSlider") as HSlider).value = audioVolume
		ChangeText()
		settings = true

func ExitSettings():
	if settings:
		TweenUtils.StopTween(tweenSettings)
		tweenSettings = TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		settings = false


func _on_h_slider_value_changed(value: float) -> void:
	soundtrackVolume = value
	GlobalSoundtrack.ChangeVolumeSettings()
	ChangeText()
	pass # Replace with function body.


func _on_audio_slider_value_changed(value: float) -> void:
	audioVolume = value
	ChangeText()
	pass # Replace with function body.


func _on_back_pressed() -> void:
	(pauseMenu as PauseScript).BringPauseFromSettings()
	ExitSettings()
	pass # Replace with function body.

func ChangeText():
	(audioText as AutoSizeRichTextLabel).text = "Audio Volume:"+str(audioVolume) +"%"
	(soundtrackText as AutoSizeRichTextLabel).text = "Track Volume:"+str(soundtrackVolume) +"%"
	pass
