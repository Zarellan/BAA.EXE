extends RichTextLabel
class_name Money_counter

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = "$ " + str(GameHandler.saveData.money)
	pass

var scaleTween:Tween
func MoneyCollected():
	if (TweenUtils.isAlive(scaleTween)):
		scaleTween.stop()
	scale = Vector2(1.2,1.2)
	scaleTween = TweenUtils.tweenScale(self,Vector2(1,1),0.3,TweenUtils.Ease.OutCirc)
