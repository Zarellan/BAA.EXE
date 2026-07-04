extends Sprite2D
class_name GrassTween

@export var start = 1.0;
@export var end = 1.0;
@export var duration = 1.0;

@export var preShadowObj:Node2D
@export var start_preShadow = 1.0;
@export var end_preShadow = 1.0;

@export var shadowObj:Node2D
@export var start_shadow = 1.0;
@export var end_shadow = 1.0;

@export var shadow_grassMain:GrassTween

@export var isShadow:bool = false
@export var skipShake:bool = false

var speedExt:float = 1.0;

var touchedGrass:bool = false # I do need to touch grass thought

var grasstw:Tween
var grasstwShadow:Tween
var grasstwPre:Tween

var nameDef = "Main"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TweenUtils.tweenSkewPingPong(self,deg_to_rad(end),deg_to_rad(start),duration,TweenUtils.Ease.InOutSine)
	#TweenUtils.tweenSkewPingPong(preShadowObj,deg_to_rad(end_preShadow),deg_to_rad(start_preShadow),duration,TweenUtils.Ease.InOutSine)
	#TweenUtils.tweenSkewPingPong(shadowObj,deg_to_rad(end_shadow),deg_to_rad(start_shadow),duration,TweenUtils.Ease.InOutSine)
	#set_process(false)
	set_physics_process(false)
	SetGrassBasedQuality()
	pass # Replace with function body.

func SetGrassBasedQuality():
	if (GameHandler.saveDataSettings.quality == GameHandler.Quality.High):
		TweenUtils.StopTween(grasstw)
		TweenUtils.StopTween(grasstwShadow)
		TweenUtils.StopTween(grasstwPre)
		TweenUtils.StopTween(grassSpeedTween)
		set_process(true)
	else:
		TweenUtils.StopTween(grasstw)
		TweenUtils.StopTween(grasstwShadow)
		TweenUtils.StopTween(grasstwPre)
		TweenUtils.StopTween(grassSpeedTween)
		grasstw = TweenUtils.tweenSkewPingPong(self,deg_to_rad(end),deg_to_rad(start),duration,TweenUtils.Ease.InOutSine)
		grasstwPre = TweenUtils.tweenSkewPingPong(preShadowObj,deg_to_rad(end_preShadow),deg_to_rad(start_preShadow),duration,TweenUtils.Ease.InOutSine)
		grasstwShadow = TweenUtils.tweenSkewPingPong(shadowObj,deg_to_rad(end_shadow),deg_to_rad(start_shadow),duration,TweenUtils.Ease.InOutSine)
		set_process(false)

var time_passed = 0;
var wavePhase:float = 0;
func SkewByMath(obj, st, en, delta):
	time_passed += delta
	
	var speed = (PI / duration / 4.2) * speedExt
	
	wavePhase += delta * speed
	var wave = sin(wavePhase)

	obj.skew = remap(wave, -1.0, 1.0, st, en)

var lastMousePos:Vector2;

var grassSpeedTween:Tween

var cooldown:float = 0;
func _process(delta: float) -> void:
	if (GameHandler.saveDataSettings.quality != GameHandler.Quality.High):
		return
	var local_mouse = get_local_mouse_position()
	var global_mouse = get_global_mouse_position()
	var distance_mouse = global_mouse.distance_to(lastMousePos)
	if (!GameHandler.GamePausedPartil() && get_rect().has_point(local_mouse) && !isShadow &&\
	distance_mouse > 60 && cooldown <= 0 && !skipShake):
		TweenUtils.StopTween(grassSpeedTween)
		grassSpeedTween = TweenUtils.tweenCustom(self,20,1,2,TweenUtils.Ease.linear,func(val):
			speedExt = val
			if (is_instance_valid(shadow_grassMain)):
				shadow_grassMain.speedExt = val
			)
		GlobalAudio.PlayOneShot("res://Sounds/grass.ogg",-4,randf_range(0.90,1.20))
		cooldown = 0.9
	lastMousePos = global_mouse
	
	SkewByMath(self, deg_to_rad(start), deg_to_rad(end), delta)
	SkewByMath(preShadowObj, deg_to_rad(start_preShadow), deg_to_rad(end_preShadow), delta)
	SkewByMath(shadowObj, deg_to_rad(start_shadow), deg_to_rad(end_shadow), delta)
	if (cooldown >= 0.0):
		cooldown -= delta
