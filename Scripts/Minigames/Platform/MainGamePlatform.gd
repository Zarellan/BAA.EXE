extends Node2D

@export var platformPrefab:PackedScene

@export var woolBarrier1:Sprite2D
@export var woolBarrier2:Sprite2D

@export var woolBarrier1Particle:GPUParticles2D
@export var woolBarrier2Particle:GPUParticles2D

var tweenScaleWool1:Tween
var tweenScaleWool2:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tweenScaleWool1 = TweenUtils.tweenScalePingPong(woolBarrier1,Vector2(0.95,1),Vector2(1.05,1),3.2,TweenUtils.Ease.InOutSine)
	tweenScaleWool2 = TweenUtils.tweenScalePingPong(woolBarrier2,Vector2(0.95,1),Vector2(1.05,1),3.2,TweenUtils.Ease.InOutSine)
	ParticleManager.PlayParticleWarmup(woolBarrier1Particle)
	ParticleManager.PlayParticleWarmup(woolBarrier2Particle)
	PlatformSpawner()
	pass # Replace with function body.


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
	print(woolBarrier1.get_parent().name)
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
		var platf = InstantiateUtil.Instantiate(platformPrefab, null)
		platf.position = Vector2(randf_range(370,900),currentYspawn)
		currentYspawn -= randf_range(120,240)
