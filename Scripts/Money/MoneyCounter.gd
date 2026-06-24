extends Control
class_name MoneyCounter

@export var moneyCounterText:AutoSizeRichTextLabel
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	moneyCounterText.text = "$" + NumberFormat.Format(GameHandler.saveData.money)
	pass

var scaleTween:Tween
func MoneyCollected():
	if (TweenUtils.isAlive(scaleTween)):
		scaleTween.stop()
	moneyCounterText.scale = Vector2(1.25,1.25)
	scaleTween = TweenUtils.tweenScale(moneyCounterText,Vector2(1,1),0.3,TweenUtils.Ease.OutCirc)
