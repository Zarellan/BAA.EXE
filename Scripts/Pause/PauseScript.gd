extends Control
class_name PauseScript

static var paused = false

@export var settings:Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paused = false
	visible = false
	pass # Replace with function body.

var tweenPause:Tween

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if !paused && !SettingsScript.settings:
			BringPause()
		elif paused && !SettingsScript.settings:
			ExitPause()
	elif (Input.is_action_just_pressed("ui_cancel") && paused):
		ExitPause()
	pass


func BringPauseFromSettings():
	if SettingsScript.settings:
		TweenUtils.StopTween(tweenPause)
		tweenPause = TweenUtils.tweenY(self,0.0,0.3,TweenUtils.Ease.OutCirc)
		paused = true

func BringPause():
	if !paused:
		TweenUtils.StopTween(tweenPause)
		tweenPause = TweenUtils.tweenY(self,0.0,0.3,TweenUtils.Ease.OutCirc)
		paused = true
		visible = true
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
		WebsiteUtil.StopSDK()
func ExitPause():
	if paused:
		TweenUtils.StopTween(tweenPause)
		tweenPause = TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		tweenPause.finished.connect(func():
			visible = false)
		paused = false
		WebsiteUtil.StartSDK()
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
func _on_resume_pressed() -> void:
	ExitPause()
	pass # Replace with function body.


func _on_save_pressed() -> void:
	GameHandler.SaveAllDataGlob()
	GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	get_tree().quit()
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	if paused:
		TweenUtils.StopTween(tweenPause)
		TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		(settings as SettingsScript).BringSettings()
		GlobalAudio.PlayOneShot("res://Sounds/menuClick.mp3",20,randf_range(0.95,1.15))
	pass # Replace with function body.


func _on_pause_button_pressed() -> void:
	if !paused && !SettingsScript.settings:
		BringPause()
	pass # Replace with function body.
