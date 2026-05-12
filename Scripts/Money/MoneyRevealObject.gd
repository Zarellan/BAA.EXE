extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TweenUtils.tweenY(self,position.y - 100,0.3,TweenUtils.Ease.OutCirc)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var tweenAlpha:Tween
func _on_timer_timeout() -> void:
	TweenUtils.tweenY(self,position.y - 100,0.3,TweenUtils.Ease.InSine)
	tweenAlpha = TweenUtils.tweenAlpha(self,0,0.3,TweenUtils.Ease.OutCirc)
	tweenAlpha.finished.connect(RemoveText)
	pass # Replace with function body.

func RemoveText():
	queue_free()
