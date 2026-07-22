extends Control
class_name Tips

static var instance:Tips

@export var texr:AutoSizeRichTextLabel
@export var tipFinishTimer:Timer

func _ready() -> void:
	instance = self
	#set_process(false)
	set_physics_process(false)
	pass # Replace with function body.


var twAlpha:Tween
func PrepareTip(tex:String, timeToFinish:float = 5):
	texr.text = tex
	TweenUtils.StopTween(twAlpha)
	twAlpha = TweenUtils.tweenAlpha(self,1,0.3,TweenUtils.Ease.linear)
	tipFinishTimer.stop()
	tipFinishTimer.start(timeToFinish)
	


func _on_tip_finished_timeout() -> void:
	TweenUtils.StopTween(twAlpha)
	twAlpha = TweenUtils.tweenAlpha(self,0,1,TweenUtils.Ease.linear)
	pass
