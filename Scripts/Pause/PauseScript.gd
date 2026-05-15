extends Control
class_name PauseScript

static var paused = false

@export var settings:Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var tweenPause:Tween
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if !paused && !SettingsScript.settings:
			BringPause()
		elif paused && !SettingsScript.settings:
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
func ExitPause():
	if paused:
		TweenUtils.StopTween(tweenPause)
		tweenPause = TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		paused = false
func _on_resume_pressed() -> void:
	ExitPause()
	pass # Replace with function body.


func _on_save_pressed() -> void:
	GameHandler.SaveAllData()
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	if paused:
		TweenUtils.StopTween(tweenPause)
		TweenUtils.tweenY(self,-get_rect().size.y,0.3,TweenUtils.Ease.InSine)
		(settings as SettingsScript).BringSettings()
	pass # Replace with function body.
