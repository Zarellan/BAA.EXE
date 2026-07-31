extends Control
class_name OfflineGrind

@export var textureBlack:Control
@export var textureCollect:Control

@export var pauseButton:Control
@export var frontPauseButtonParent:Control
@export var backPauseButtonParent:Control

@export var infoText:AutoSizeRichTextLabel
static var isOfflineGrind:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isOfflineGrind = false
	await RenderingServer.frame_post_draw
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func BringOfflineCollect(money, time):
	if (!isOfflineGrind):
		TweenUtils.tweenAlphaSelf(textureBlack,0.5,0.3,TweenUtils.Ease.linear)
		TweenUtils.tweenY(textureCollect,120.0,0.3,TweenUtils.Ease.OutCirc)
		pauseButton.reparent(frontPauseButtonParent)
		SetTextInfo(money, time)
		isOfflineGrind = true

func SetTextInfo(money, time):
	infoText.text = "the auto collectors collected %s for you while you were away for %s" % [NumberFormat.Format(money) , time]
