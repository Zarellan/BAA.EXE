class_name TweenUtils

enum Ease{
	OutCirc,
	InSine,
	InOutSine,
	linear
	}


static func isAlive(twen:Tween):
	if (twen != null && twen.is_valid()):
		return true
	return false

static func StopTween(twen:Tween):
	if (twen != null && twen.is_valid()):
		twen.stop()


static func EasingType(tween, easing:Ease):
	var eas = Tween.EASE_IN_OUT
	var transition = Tween.TRANS_LINEAR
	
	match easing:
		Ease.OutCirc: 
			eas = Tween.EASE_OUT
			transition = Tween.TRANS_CIRC
		Ease.InSine: 
			eas = Tween.EASE_IN
			transition = Tween.TRANS_SINE

		Ease.InOutSine:
			eas = Tween.EASE_IN_OUT
			transition = Tween.TRANS_SINE
		Ease.linear:
			eas = Tween.EASE_IN_OUT
			transition = Tween.TRANS_LINEAR
	tween.set_trans(transition).set_ease(eas)

static func tweenX(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "position:x", position, duration)
	EasingType(step, eas)
	return tween

static func tweenY(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "position:y", position, duration)
	EasingType(step, eas)
	return tween

static func tweenRotation(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "rotation_degrees", position, duration)
	EasingType(step, eas)
	return tween

static func tweenColor(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "modulate", position, duration)
	EasingType(step, eas)
	return tween

static func tweenColorRGB(object, color, duration, eas):
	var tween = object.create_tween()
	var currentColor = object.modulate
	var step = tween.tween_method(func(col):
		object.modulate.r = col.r
		object.modulate.g = col.g
		object.modulate.b = col.b
	, currentColor, color, duration)
	EasingType(step, eas)
	return tween

static func tweenAlpha(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "modulate:a", position, duration)
	EasingType(step, eas)
	return tween
	
static func tweenNumber(owner, objectValue:ValueSaver,value,duration,eas):
	var tween = owner.create_tween()
	var currentInt = objectValue.number

	var step = tween.tween_method(func(integral):
		if is_instance_valid(objectValue):
			objectValue.number = integral
	, currentInt, value, duration)

	EasingType(step, eas)
	return tween

static func tweenScale(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scale", position, duration)
	EasingType(step, eas)
	return tween

static func tweenScaleX(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scale:x", position, duration)
	EasingType(step, eas)
	return tween

static func tweenScaleY(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scale:y", position, duration)
	EasingType(step, eas)
	return tween

static func tweenSkew(object,value,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "skew", value, duration)
	EasingType(step, eas)
	return tween

static func tweenSkewPingPong(object,startValue,endValue,duration,eas):
	var tween = object.create_tween().set_loops(-1)
	
	var step1 = tween.tween_property(object, "skew", startValue, duration)
	EasingType(step1, eas)

	var step2 = tween.tween_property(object, "skew", endValue, duration)
	EasingType(step2, eas)

	return tween

static func tweenScrollY(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scroll_vertical", position, duration)
	EasingType(step, eas)
	return tween
