extends StaticBody2D

@export var visibleNotifier:VisibleOnScreenNotifier2D
@export var collision:CollisionShape2D
var isHiding = false
var hiddenStatic = false

var scored = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibleNotifier.screen_exited.connect(func():
		hiddenStatic = true)
	visibleNotifier.screen_entered.connect(func():
		hiddenStatic = false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y + 60):
		collision.disabled = false
	else:
		collision.disabled = true
	if (hiddenStatic && position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y):
		HidePlatform()
	
	CountPoint()
	pass

func CountPoint():
	if (!scored && position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y + 60):
		PlatformMinigame.IncScore()
		scored = true
func HidePlatform():
	if (isHiding):
		return
	TweenUtils.tweenAlpha(self,0,0.8,TweenUtils.Ease.linear).finished.connect(func():
		queue_free())
	isHiding = true
