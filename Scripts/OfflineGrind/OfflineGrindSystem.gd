extends Control
class_name OfflineGrind

@export var textureBlack:Control
@export var textureCollect:Control

@export var pauseButton:Control
@export var frontPauseButtonParent:Control
@export var backPauseButtonParent:Control

@export var infoText:AutoSizeRichTextLabel
static var isOfflineGrind:bool = false

var tweenGrindPanel:Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isOfflineGrind = false
	visible = false
	set_process(false)
	set_physics_process(false)
	if (!WebsiteUtil.adSupport):
		SetButtonsNoAds()
	await RenderingServer.frame_post_draw
	pass # Replace with function body.

func SetButtonsNoAds():
	get_node("CollectTex/Collect").position.x = 210.0
	get_node("CollectTex/Collect2").visible = false


func BringOfflineCollect(money, time):
	if (!isOfflineGrind):
		TweenUtils.tweenAlphaSelf(textureBlack,0.5,0.3,TweenUtils.Ease.linear)
		TweenUtils.tweenY(textureCollect,120.0,0.3,TweenUtils.Ease.OutCirc)
		pauseButton.reparent(frontPauseButtonParent)
		SetTextInfo(money, time)
		visible = true
		isOfflineGrind = true

func QuitOfflineCollect():
	if (isOfflineGrind):
		TweenUtils.tweenAlphaSelf(textureBlack,0,0.3,TweenUtils.Ease.linear)
		tweenGrindPanel = TweenUtils.tweenY(textureCollect,-598.0,0.3,TweenUtils.Ease.InSine)
		tweenGrindPanel.finished.connect(func():
			visible = false)
		pauseButton.reparent(backPauseButtonParent)
		isOfflineGrind = false

func SetTextInfo(money, time):
	infoText.text = "the auto collectors collected %s for you while you were away for %s" % [NumberFormat.Format(money) , time]

func _on_collect_pressed() -> void:
	GameHandler.CollectWhatLeft(1)
	QuitOfflineCollect()
	pass # Replace with function body.


func _on_collect_2_pressed() -> void:
	WebsiteUtil.play_ad_award(func():
		GameHandler.CollectWhatLeft(3)
		QuitOfflineCollect())
	pass # Replace with function body.
