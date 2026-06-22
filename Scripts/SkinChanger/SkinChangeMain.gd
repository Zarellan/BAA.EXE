extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var skinChangeTween:Tween
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if (Input.is_action_just_pressed("Key_A") && !SkinChanger.isSkinChanging):
		#BringSkinChanger()
	if (SkinChanger.isSkinChanging && Input.is_action_just_pressed("ui_cancel")):
		ExitSkinChanger()
	
	pass

func BringSkinChanger():
	TweenUtils.StopTween(skinChangeTween)
	skinChangeTween = TweenUtils.tweenY(self,0,0.3,TweenUtils.Ease.OutCirc)
	get_node("SubViewportContainer/SubViewport/SkinChanger").PrepSkin()
	SkinChanger.isSkinChanging = true

func ExitSkinChanger():
	TweenUtils.StopTween(skinChangeTween)
	skinChangeTween = TweenUtils.tweenY(self,-720.0,0.3,TweenUtils.Ease.InSine)
	SkinChanger.isSkinChanging = false


func _on_skins_button_pressed() -> void:
	if (!SkinChanger.isSkinChanging):
		BringSkinChanger()
	else:
		ExitSkinChanger()
	pass # Replace with function body.


func _on_back_pressed() -> void:
	if (SkinChanger.isSkinChanging):
		ExitSkinChanger()
	pass # Replace with function body.
