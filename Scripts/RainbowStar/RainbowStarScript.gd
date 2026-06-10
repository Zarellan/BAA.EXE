extends Sprite2D

@export var movement_curve: Curve
@export var movement_curve2: Curve

@export var rotation_curve1: Curve
@export var scale_curve1: Curve

var randX:float
var randY:float
var randRot:float
var randScale:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randX = randf_range(-200,200)
	while (randX < 50 && randX > -50):
		randX = randf_range(-200,200)
	randY = randf_range(400,500)
	randRot = randf_range(-20,20)
	while (randRot < 10 && randRot > -10):
		randRot = randf_range(-20,20)
	randScale = randf_range(1.0,1.6)
	scale_curve1.set_point_value(1,randScale)
	get_node("Timer").wait_time = randf_range(4,8)
	pass # Replace with function body.

var elaps1 = 0
var elaps2 = 0
var elapscurve1 = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elaps1 += delta * 2
	elapscurve1 += delta * 2
	if (elaps1 < 1.0):
		position.y -= movement_curve.sample(elaps1) * randY * delta
		position.x -= movement_curve.sample(elaps1) * randX * delta
		rotation_degrees += randRot * delta
		scale = Vector2.ONE * scale_curve1.sample(elaps1)

	if (elaps1 >= 1):
		elaps2 += delta / 10
		position.y += movement_curve2.sample(elaps2) * 150 * delta
		rotation_degrees += movement_curve2.sample(elaps2) * randRot * 10 * delta
		pass
	
	
	pass

var twAlph:Tween
func _on_timer_timeout() -> void:
	twAlph = TweenUtils.tweenAlpha(self,0,0.3,TweenUtils.Ease.linear)
	twAlph.finished.connect(func():
		queue_free.call_deferred()
		RainbowStarParticle.added -= 1)
	pass # Replace with function body.
