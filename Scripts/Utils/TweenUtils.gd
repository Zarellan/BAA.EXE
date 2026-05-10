class_name TweenUtils


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func tweenX(object,position,duration,trans,ease = Tween.EASE_IN_OUT):
	var tween = object.create_tween()
	tween.tween_property(object, "position:x", position, duration).set_trans(trans).set_ease(ease)
	return tween

static func tweenY(object,position,duration,trans,ease = Tween.EASE_IN_OUT):
	var tween = object.create_tween()
	tween.tween_property(object, "position:y", position, duration).set_trans(trans).set_ease(ease)
	return tween

static func tweenScaleX(object,position,duration,trans,ease = Tween.EASE_IN_OUT):
	var tween = object.create_tween()
	tween.tween_property(object, "scale:x", position, duration)\
	.set_trans(trans)\
	.set_ease(ease)
	return tween

static func tweenScaleY(object,position,duration,trans,ease = Tween.EASE_IN_OUT):
	var tween = object.create_tween()
	tween.tween_property(object, "scale:y", position, duration)\
	.set_trans(trans)\
	.set_ease(ease)
	return tween

static func tweenSkew(object,value,duration,trans,ease = Tween.EASE_IN_OUT):
	var tween = object.create_tween()
	tween.tween_property(object, "skew", value, duration)\
	.set_trans(trans)\
	.set_ease(ease)
	return tween

static func tweenSkewPingPong(object,startValue,endValue,duration,trans,ease = Tween.EASE_IN_OUT):
	var tween = object.create_tween().set_loops()

	tween.tween_property(object, "skew", endValue, duration)\
		.set_trans(trans)\
		.set_ease(ease)

	tween.tween_property(object, "skew", startValue, duration)\
		.set_trans(trans)\
		.set_ease(ease)

	return tween
