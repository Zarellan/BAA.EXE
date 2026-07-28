extends Node
class_name RebirthCounter

@export var rebirthText:Control
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rebirthText.text = NumberFormat.Format(GameHandler.saveDataRebirth.rebirth)
	pass

#var scaleTween:Tween
#func MoneyCollected():
	#if (TweenUtils.isAlive(scaleTween)):
		#scaleTween.stop()
	#get_parent().scale = Vector2(1.25,1.25)
	#scaleTween = TweenUtils.tweenScale(get_parent(),Vector2(1,1),0.3,TweenUtils.Ease.OutCirc)
