extends Control

@export var holder:Control
@export var BG:Control
@export var BG2:Control

@export var titleText:Control
@export var descText:Control
@export var image:Control

var soundPlays:Array[AudioStreamPlayer]
var volumeTween:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#PlayAchievement()
	pass # Replace with function body.

var twHolderAlpha:Tween
var twHolderScale:Tween

var twBGScale:Tween

func PlayAchievement(ti:String = "title", desc:String = "desc", img:Texture2D = null):
	TweenUtils.StopTween(twBGScale)
	holder.modulate.a = 0
	TweenUtils.StopTween(twHolderAlpha)
	twHolderAlpha = TweenUtils.tweenAlpha(holder,1,0.3,TweenUtils.Ease.linear)
	holder.scale = Vector2(1.2,1.2)
	TweenUtils.StopTween(twHolderScale)
	twHolderScale = TweenUtils.tweenScale(holder,Vector2(1,1),0.5,TweenUtils.Ease.OutCirc)
	BG2.self_modulate.a = 1
	BG.modulate.a = 0
	titleText.text = ti
	descText.text = desc
	image.texture = img
	get_node("WhenWhiteAlpha").start(0.5)
	get_node("FinishShow").start(3)
	for i in range(soundPlays.size()):
		if is_instance_valid(soundPlays[i]):
			soundPlays[i].stop()
	soundPlays.clear()
	soundPlays.append(GlobalAudio.PlayOneShot("res://Sounds/RebirthBought.mp3", -3))
	soundPlays.append(GlobalAudio.PlayOneShot("res://Sounds/bought.mp3", 0))
	soundPlays.append(GlobalAudio.PlayOneShot("res://Sounds/achievement.ogg", 0))
	TweenUtils.StopTween(volumeTween)
	volumeTween = TweenUtils.tweenCustom(self,GlobalSoundtrack.audioDiv,10,0.4,TweenUtils.Ease.linear,func(val):
		GlobalSoundtrack.audioDiv = val
		GlobalSoundtrack.ChangeVolumeSettings())


func _on_when_white_alpha_timeout() -> void:
	BG.modulate.a = 1
	twBGScale = TweenUtils.tweenAlphaSelf(BG2,0,0.5,TweenUtils.Ease.linear)
	pass # Replace with function body.


func _on_finish_show_timeout() -> void:
	TweenUtils.StopTween(twHolderAlpha)
	twHolderAlpha = TweenUtils.tweenAlpha(holder,0,2,TweenUtils.Ease.linear)
	volumeTween = TweenUtils.tweenCustom(self,GlobalSoundtrack.audioDiv,1,0.4,TweenUtils.Ease.linear,func(val):
		GlobalSoundtrack.audioDiv = val
		GlobalSoundtrack.ChangeVolumeSettings())
	pass # Replace with function body.
