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

var died = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (instance == null):
		instance = self
	tweenScaleWool1 = TweenUtils.tweenScalePingPong(woolBarrier1,Vector2(0.95,1),Vector2(1.05,1),3.2,TweenUtils.Ease.InOutSine)
	tweenScaleWool2 = TweenUtils.tweenScalePingPong(woolBarrier2,Vector2(0.95,1),Vector2(1.05,1),3.2,TweenUtils.Ease.InOutSine)
	ParticleManager.PlayParticleWarmup(woolBarrier1Particle)
	ParticleManager.PlayParticleWarmup(woolBarrier2Particle)
	PlatformSpawner()
	died = false
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/PlatformMinigame.mp3")
	
	#modify_curve_domain()
	pass # Replace with function body.

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
	

	curveDistance.max_domain = 55000.0
	
	var old_x = old_pos.x if old_pos.x != 0 else 1.0
	var scale_factor = 55000.0 / old_x
	if scale_factor != 0:
		left_tangent = left_tangent / scale_factor
		right_tangent = right_tangent / scale_factor

	var new_pos = Vector2(55000.0, 15.0)
	
	curveDistance.remove_point(last_index)
	curveDistance.add_point(new_pos, left_tangent, right_tangent, left_mode, right_mode)
	
	curveDistance.emit_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	ParticleManager.PlayParticleOv(woolBarrier2Particle,randf_range(12,26),woolBarrier2.get_parent())
	pass # Replace with function body.

var currentYspawn:float = 358.0

var maxSpawnY:float = currentYspawn - 3000
func PlatformSpawner():
	while (currentYspawn > maxSpawnY):
		var platf = InstantiateUtil.Instantiate(platformPrefab, self)
		platf.position = Vector2(CalculateBasedOfZoomXrng(platf),currentYspawn)
		currentYspawn -= clamp(randf_range(45 * curveDistance.sample(absf(player.global_position.y)),\
		45 * curveDistance.sample(absf(player.global_position.y))),0,1000) # yeah I won't make it unbeatable
		CalculateBasedOfZoomXrng(platf)

func CalculateBasedOfZoomXrng(platform):
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
	instance.textScore.text = str(score)
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
	died = true
	pass
