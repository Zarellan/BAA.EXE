extends Node2D
class_name PlatformMinigame

static var instance:PlatformMinigame
static var score = 0
@export var platformPrefab:PackedScene

@export var woolBarrier1:Sprite2D
@export var woolBarrier2:Sprite2D

@export var woolBarrier1Particle:GPUParticles2D
@export var woolBarrier2Particle:GPUParticles2D

@export var textScore:Control
var tweenScaleWool1:Tween
var tweenScaleWool2:Tween

@export var curveDistance:Curve
@export var player:CharacterBody2D
@export var camera:Camera2D

@export var max_difficulty_height: float = -10000.0

@export var phoneButtons:Array[Control]
var died = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if (instance == null):
	instance = self # the class isn't singleton so it's better to always instance when loaded to this scene
	tweenScaleWool1 = TweenUtils.tweenScalePingPong(woolBarrier1,Vector2(0.95,1),Vector2(1.05,1),3.2,TweenUtils.Ease.InOutSine)
	tweenScaleWool2 = TweenUtils.tweenScalePingPong(woolBarrier2,Vector2(0.95,1),Vector2(1.05,1),3.2,TweenUtils.Ease.InOutSine)
	ParticleManager.PlayParticleWarmup(woolBarrier1Particle)
	ParticleManager.PlayParticleWarmup(woolBarrier2Particle)
	PlatformSpawner()
	died = false
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/PlatformMinigame.mp3")
	
	modify_curve_domain()
	isPhone()
	pass

func isPhone():
	if (!DeviceCheckerUtil.IsUsingPhone()):
		for i in range(phoneButtons.size()):
			phoneButtons[i].visible = false
func modify_curve_domain():
	if not curveDistance:
		push_error("curveDistance is not assigned!")
		return
		
	var last_index = curveDistance.point_count - 1
	if last_index < 0:
		return
		
	var old_pos = curveDistance.get_point_position(last_index)
	var left_tangent = curveDistance.get_point_left_tangent(last_index)
	var right_tangent = curveDistance.get_point_right_tangent(last_index)
	var left_mode = curveDistance.get_point_left_mode(last_index)
	var right_mode = curveDistance.get_point_right_mode(last_index)
	

	curveDistance.max_domain = GameHandler.saveDataRebirth.curveDistance
	
	var old_x = old_pos.x if old_pos.x != 0 else 1.0
	var scale_factor = GameHandler.saveDataRebirth.curveDistance / old_x
	if scale_factor != 0:
		left_tangent = left_tangent / scale_factor
		right_tangent = right_tangent / scale_factor

	var new_pos = Vector2(GameHandler.saveDataRebirth.curveDistance\
	, GameHandler.saveDataRebirth.curveValue)
	
	curveDistance.remove_point(last_index)
	curveDistance.add_point(new_pos, left_tangent, right_tangent, left_mode, right_mode)
	
	curveDistance.emit_changed()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (maxSpawnY > get_tree().get_first_node_in_group("PlayerPlatform").position.y - 1000):
		maxSpawnY = currentYspawn - 500
		PlatformSpawner()
	
	pass


func _on_wool_barrier_collision_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("PlayerPlatform")):
		return
	TweenUtils.StopTween(tweenScaleWool1)
	woolBarrier1.scale.x = 0.85
	tweenScaleWool1 = TweenUtils.tweenScaleX(woolBarrier1,1,0.6,TweenUtils.Ease.OutCirc)
	ParticleManager.PlayParticleOv(woolBarrier1Particle,randf_range(12,26),woolBarrier1.get_parent())
	pass # Replace with function body.


func _on_wool_barrier_collision_2_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("PlayerPlatform")):
		return
	TweenUtils.StopTween(tweenScaleWool2)
	woolBarrier2.scale.x = 0.85
	tweenScaleWool2 = TweenUtils.tweenScaleX(woolBarrier2,1,0.6,TweenUtils.Ease.OutCirc)
	ParticleManager.PlayParticleOv(woolBarrier2Particle,randf_range(12.0,26.0),woolBarrier2.get_parent())
	pass # Replace with function body.

var currentYspawn:float = 358.0

var maxSpawnY:float = currentYspawn - 3000
func PlatformSpawner():
	while (currentYspawn > maxSpawnY):
		var platf = InstantiateUtil.Instantiate(platformPrefab, self)
		platf.position = Vector2(CalculateBasedOfZoomXrng(),currentYspawn)

		var current_scale = lerpf(2.077, 0.5, curveDistance.sample(absf(player.global_position.y))/ curveDistance.max_value)
		platf.platformType = PlatformType()
		(platf as PlatformWay).speed = DefinePlatformSpeed(platf.platformType)
		platf.scale.x = current_scale
		currentYspawn -= clamp(randf_range(45 * curveDistance.sample(absf(player.global_position.y)),\
		45 * curveDistance.sample(absf(player.global_position.y))),0,1000)
		CalculateBasedOfZoomXrng()

var moveStart = 4.5
func PlatformType():
	# 1. Check if the player has crossed the moveStart threshold
	if (curveDistance.sample(absf(player.global_position.y)) >= moveStart):
		
		var currentDistance = curveDistance.sample(absf(player.global_position.y))
		
		var normalizedDistance = (currentDistance - moveStart) / (curveDistance.max_value - moveStart)
		if (randf_range(0.0,1.0) < lerpf(0.0,0.5,normalizedDistance)):
			return PlatformWay.Type.move
	return PlatformWay.Type.normal

func DefinePlatformSpeed(type: PlatformWay.Type):
	# 1. FIX: Slide the parenthesis back so .sample() closes before checking >= moveStart
	if (curveDistance.sample(absf(player.global_position.y)) >= moveStart \
	&& type == PlatformWay.Type.move):
		
		var current_curve_val = curveDistance.sample(absf(player.global_position.y))
		
		var normalized_ratio = (current_curve_val - moveStart) / (curveDistance.max_value - moveStart)
		normalized_ratio = clampf(normalized_ratio, 0.0, 1.0)
		
		var base_speed = lerpf(100.0, 600.0, normalized_ratio)
		
		var final_speed = base_speed * randf_range(0.85, 1.15)
		
		return clampf(final_speed, 100.0, 600.0)
	return 0.0

func CalculateBasedOfZoomXrng():
	var screen_x = camera.global_position.x
	var plaformWidth = 265
	
	var dynamicWidth = plaformWidth / camera.zoom.x
	var value = Vector2(screen_x - dynamicWidth, screen_x + dynamicWidth)
	return randf_range(value.x, value.y)
	

func CameraZoom():
	var height_ratio = abs(player.global_position.y) / 20000.0
	height_ratio = clamp(height_ratio, 0.0, 1.0)
	var target_zoom_val = lerp(1.0, 0.5, height_ratio)
	target_zoom_val = snapped(target_zoom_val,0.1)
	TweenUtils.tweenCustom(self, camera.zoom.x, target_zoom_val, 2.0, TweenUtils.Ease.OutCirc, func(val): 
		camera.zoom = Vector2(val,val)
		var inverse_scale = 1.0 / camera.zoom.x
		camera.scale = Vector2(inverse_scale, inverse_scale)
		)

static func IncScore():
	score += 1
	if score == 67:
		instance.textScore.text = str(score-1) + " + 1"
	else:
		instance.textScore.text = str(score)
	if (score >= 20):
		GameHandler.UnlockSkin("Jump")
	instance.textScore.scale = Vector2(randf_range(0.6,1.5),randf_range(0.6,1.5))
	TweenUtils.tweenScale(instance.textScore,Vector2.ONE,0.3,TweenUtils.Ease.OutCirc)
	pass

var twVolume:Tween
func GameOver():
	if (died):
		return
	TweenUtils.tweenCustom(self, 1, 0.3, 2, TweenUtils.Ease.linear, func(val): 
		GlobalSoundtrack.pitch_scale = val).finished.connect(func():
			TweenUtils.tweenCustom(self, 0, -80, 4, TweenUtils.Ease.linear, func(val): 
				GlobalSoundtrack.volume_db = val))
	if (GameHandler.saveDataAchievements.platformMinigameScore < score):
		GameHandler.saveDataAchievements.platformMinigameScore = score
	GameHandler.SaveAllDataGlob()
	died = true
	pass
