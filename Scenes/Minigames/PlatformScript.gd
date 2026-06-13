extends StaticBody2D

@export var visibleNotifier:VisibleOnScreenNotifier2D

var isHiding = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibleNotifier.screen_exited.connect(HidePlatform)
	pass # Replace with function body.




func HidePlatform():
	if (isHiding):
		return
	TweenUtils.tweenAlpha(self,0,0.8,TweenUtils.Ease.linear).finished.connect(func():
		queue_free())
	isHiding = true
