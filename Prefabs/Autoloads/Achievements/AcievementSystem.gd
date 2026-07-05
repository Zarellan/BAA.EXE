extends Control

@export var holder:Control
@export var BG:Control
@export var BG2:Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayAchievement()
	pass # Replace with function body.


func PlayAchievement():
	holder.modulate.a = 0
	TweenUtils.tweenAlpha(holder,1,0.3,TweenUtils.Ease.linear)
	holder.scale = Vector2(1.2,1.2)
	TweenUtils.tweenScale(holder,Vector2(1,1),0.5,TweenUtils.Ease.OutCirc)
	BG2.self_modulate.a = 1
	BG.modulate.a = 0
	get_node("WhenWhiteAlpha").start(0.5)
	GlobalAudio.PlayOneShot("res://Sounds/RebirthBought.mp3", 3)
	GlobalAudio.PlayOneShot("res://Sounds/bought.mp3", 3)
	GlobalAudio.PlayOneShot("res://Sounds/Achievement2.wav", 20)
	GlobalAudio.PlayOneShot("res://Sounds/Achievement.wav", 20)


func _on_when_white_alpha_timeout() -> void:
	BG.modulate.a = 1
	TweenUtils.tweenAlphaSelf(BG2,0,0.5,TweenUtils.Ease.linear)
	pass # Replace with function body.
