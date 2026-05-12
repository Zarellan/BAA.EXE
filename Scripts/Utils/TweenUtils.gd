class_name TweenUtils

enum Ease{
	OutCirc,
	InSine,
	InOutSine
	}


static func isAlive(twen:Tween):
	if (twen != null && twen.is_valid()):
		return true
	return false
	pass

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
	tween.set_trans(transition).set_ease(eas)

static func tweenX(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "position:x", position, duration)
	EasingType(step, eas)
	return tween

static func tweenY(object,position,duration,eas):
	print("Twe")
	var tween = object.create_tween()
	var step = tween.tween_property(object, "position:y", position, duration)
	EasingType(step, eas)
	return tween

static func tweenAlpha(object,position,duration,eas):
	print("Twe")
	var tween = object.create_tween()
	var step = tween.tween_property(object, "modulate:a", position, duration)
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
