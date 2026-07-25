extends Node

@export var background: TextureRect
@export var sheep: Sprite2D
@export var textTitle: Control
var twTextScale1:Tween
var twTextScale2:Tween

var twTextY1:Tween
var twTextY2:Tween

var currentTextY:float

var leftForFall = 0

var skewSheepTween:Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentTextY = textTitle.position.y
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/MainMenu.mp3")
	#ResourceLoader.load_threaded_request(scenePath)
	TweenUtils.tweenScalePingPong(background,Vector2(1,1.05),Vector2(1,1),2,TweenUtils.Ease.InOutSine)
	skewSheepTween = TweenUtils.tweenSkewPingPong(sheep,-0.04,0.04,1,TweenUtils.Ease.InOutSine)
	TweenTextJump()
	pass # Replace with function body.

func TweenTextJump():
	if leftForFall <= 2: # keep jumping
		twTextY1 = TweenUtils.tweenY(textTitle, currentTextY + 20, 0.3,TweenUtils.Ease.InSine)
		twTextScale1 = TweenUtils.tweenScale(textTitle,Vector2(1.1,0.9),0.3,TweenUtils.Ease.InSine)
		twTextScale1.finished.connect(func():
				twTextY2 = TweenUtils.tweenY(textTitle, currentTextY, 0.3,TweenUtils.Ease.OutCirc)
				twTextScale2 = TweenUtils.tweenScale(textTitle,Vector2.ONE,0.3,TweenUtils.Ease.OutCirc)
				twTextScale2.finished.connect(TweenTextJump))
		leftForFall += 1
	else: # poor sheep
		twTextY1 = TweenUtils.tweenY(textTitle, currentTextY + 230, 0.7,TweenUtils.Ease.InSine)
		twTextScale1 = TweenUtils.tweenScale(textTitle,Vector2(1.1,0.9),0.7,TweenUtils.Ease.InSine)
		twTextScale1.finished.connect(func():
				TweenUtils.StopTween(skewSheepTween)
				sheep.scale.y = 4.0
				sheep.modulate = Color(1,0,0)
				TweenUtils.tweenScaleY(sheep,4.73,1,TweenUtils.Ease.OutCirc)
				TweenUtils.tweenAlpha(sheep,1,1,TweenUtils.Ease.OutCirc)
				skewSheepTween = TweenUtils.tweenSkewPingPong(sheep,-0.04,0.04,0.3,TweenUtils.Ease.InOutSine)
				currentTextY = textTitle.position.y
				twTextY2 = TweenUtils.tweenY(textTitle, currentTextY - 50, 0.3,TweenUtils.Ease.OutCirc)
				twTextScale2 = TweenUtils.tweenScale(textTitle,Vector2.ONE,0.3,TweenUtils.Ease.OutCirc)
				twTextScale2.finished.connect(func():
					TweenUtils.tweenY(textTitle, currentTextY + 380, 0.7,TweenUtils.Ease.InSine)))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
