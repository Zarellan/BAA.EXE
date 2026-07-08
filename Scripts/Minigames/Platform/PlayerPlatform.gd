extends CharacterBody2D
class_name PlayerPlatform

const rotationSpeed = 2
var JUMP_VELOCITY = 0

var jump_angle: float = 0.0
var xPow = 0
var jumpVector:Vector2 = Vector2.ZERO

var jumped = true

@export var anchorArrow:Marker2D
@export var camera:Camera2D
@export var sprite:Sprite2D
@export var dirtParticle:GPUParticles2D

var stomped = false
var skewTween:Tween

var camTween:Tween

var defaultScale = Vector2()

var twScaleSprite:Tween

var prevVelocityY = 0
func _ready() -> void:
	JUMP_VELOCITY = -GameHandler.TotalJumpPower()
	defaultScale = sprite.scale
	ParticleManager.PlayParticleWarmup(dirtParticle)
func _physics_process(delta: float) -> void:
	anchorArrow.position = $Sprite2D/Nodo.global_position

	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = -jumpVector.x
		anchorArrow.visible = false
		prevVelocityY = velocity.y
		ControlInAir(delta)
		HitBarrier()
		HitBarrier2()
	else:
		velocity.x = 0
		jumpVector.x = 0
		anchorArrow.visible = true
		if (jumped):
			camTween = TweenUtils.tweenY(camera,position.y - 100,0.5,TweenUtils.Ease.OutCirc)
			TweenUtils.StopTween(twScaleSprite)
			if (!stomped):
				sprite.scale = Vector2(defaultScale.x + 0.3,defaultScale.y - 0.5)
			else:
				sprite.scale = Vector2(defaultScale.x + 0.6,defaultScale.y - 0.5)
				GlobalAudio.PlayOneShot("res://Sounds/impactStomp.ogg",0,randf_range(0.95,1.05))
				(camera as CameraShake).add_trauma(0.25)
			twScaleSprite = TweenUtils.tweenScale(sprite,defaultScale,0.5,TweenUtils.Ease.OutCirc)
			skewTween = TweenUtils.tweenSkewPingPong(sprite,deg_to_rad(-10),deg_to_rad(10),0.4,TweenUtils.Ease.InOutSine)
			PlatformMinigame.instance.CameraZoom()
			GlobalAudio.PlayOneShot("res://Sounds/land.mp3",0,randf_range(0.95,1.05))
			var impactParticle = 0
			if (platform != null):
				impactParticle = platform.JumpedOn(prevVelocityY, stomped)
				ParticleManager.PlayParticleOv(dirtParticle,int(impactParticle))
			stomped = false

		jumped = false

	if (Input.is_action_just_pressed("ui_accept") || touchedUp) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumped = true
		TweenUtils.StopTween(twScaleSprite)
		sprite.scale = Vector2(defaultScale.x * 0.6,defaultScale.y  * 1.6)
		twScaleSprite = TweenUtils.tweenScale(sprite,defaultScale,0.5,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(skewTween)
		TweenUtils.tweenSkew(sprite,deg_to_rad(0),0.4,TweenUtils.Ease.OutCirc)
		GlobalAudio.PlayOneShot("res://Sounds/jump.mp3",-6)
		touchedUp = false
	Stomping()
	var direction := Input.get_axis("ui_left", "ui_right")
	direction += int(touchedRight) - int(touchedLeft)
	if is_on_floor():
		jump_angle += direction * rotationSpeed * delta
		
		jump_angle = clamp(jump_angle, deg_to_rad(-75), deg_to_rad(75))
		
		jumpVector = Vector2.UP.rotated(jump_angle) * JUMP_VELOCITY

		anchorArrow.rotation = jump_angle
	if is_on_floor():
		anchorArrow.rotation = jumpVector.angle() - deg_to_rad(90)
	#ForceCameraFollow(delta)
	FlipSprite()
	CameraMax()
	CameraMaxGameOver()
	move_and_slide()

func ControlInAir(delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	direction += int(touchedRight) - int(touchedLeft)
	jumpVector.x += -direction * GameHandler.TotalAirAcceleration() * delta
func FlipSprite():
	if (jumpVector.x > 0):
		sprite.flip_h = false
		sprite.get_node("Shadow").flip_h = false
	else:
		sprite.flip_h = true
		sprite.get_node("Shadow").flip_h = true
func Stomping():
	if (Input.is_action_just_pressed("ui_down") \
	&& !is_on_floor() \
	&& !stomped \
	&& GameHandler.saveDataRebirth.powerStomp):
		xPow = 0
		jumpVector.x = 0
		velocity.x = 0
		velocity.y = 1500
		sprite.scale = Vector2(defaultScale.x * 0.7,defaultScale.y * 1.3)
		GlobalAudio.PlayOneShot("res://Sounds/droppingSound.ogg",0,randf_range(0.90,0.99))
		GlobalAudio.PlayOneShot("res://Sounds/droppingSound.ogg",0,randf_range(1.03,1.15))
		stomped = true
		while (stomped):
			var obj = get_node("Sprite2D").duplicate()
			obj.offset = Vector2(0,0)
			obj.get_node("Shadow").offset = Vector2(0,0)
			obj.ready.connect(func():
				TweenUtils.tweenScale(obj,Vector2(1.3,0.7),0.3,TweenUtils.Ease.linear)
				TweenUtils.tweenAlpha(obj,0,0.3,TweenUtils.Ease.linear).finished.connect(func():
					obj.queue_free())
			)
			get_tree().current_scene.add_child(obj)
			obj.global_position = self.global_position
			await get_tree().create_timer(0.04).timeout

func CameraMax():
	var deadZone = 200.0 / camera.zoom.y
	if (global_position.y < camera.global_position.y - deadZone):
		camera.global_position.y = global_position.y + deadZone
		TweenUtils.StopTween(camTween)

func CameraMaxGameOver():
	var deadZone = 400.0 / camera.zoom.y
	if (global_position.y > camera.global_position.y + deadZone):
		PlatformMinigame.instance.GameOver()

var enteredBarrier = false
func _on_wool_barrier_collision_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("PlayerPlatform")):
		return
	enteredBarrier = true
	pass
func _on_wool_barrier_collision_body_exited(body: Node2D) -> void:
	if (!body.is_in_group("PlayerPlatform")):
		return
	enteredBarrier = false
	pass # Replace with function body.

func HitBarrier():
	if (enteredBarrier && jumpVector.x > 0):
		jumpVector.x = -jumpVector.x
		WoolHitEffect()
var enteredBarrier2 = false
func _on_wool_barrier_collision_2_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("PlayerPlatform")):
		return
	enteredBarrier2 = true
	pass # Replace with function body.

func _on_wool_barrier_collision_2_body_exited(body: Node2D) -> void:
	if (!body.is_in_group("PlayerPlatform")):
		return
	enteredBarrier2 = false
	pass # Replace with function body.

func HitBarrier2():
	if (enteredBarrier2 && jumpVector.x < 0):
		jumpVector.x = -jumpVector.x
		WoolHitEffect()

func WoolHitEffect():
	GlobalAudio.PlayOneShot("res://Sounds/cut_sound.ogg",6,randf_range(0.95,1.05))
	GlobalAudio.PlayOneShot("res://Sounds/cut_sound.ogg",6,randf_range(0.85,0.95))
	GlobalAudio.PlayOneShot("res://Sounds/land.mp3",0,randf_range(1.30,1.50))
	GlobalAudio.PlayOneShot("res://Sounds/land.mp3",0,randf_range(1.15,1.30))

var touchedLeft = false
func _on_left_touch_touched() -> void:
	touchedLeft = true
	pass # Replace with function body.


func _on_left_touch_untouched() -> void:
	touchedLeft = false
	pass # Replace with function body.

var touchedRight = false
func _on_right_touch_touched() -> void:
	touchedRight = true
	pass # Replace with function body.


func _on_right_touch_untouched() -> void:
	touchedRight = false
	pass # Replace with function body.

var touchedUp = false
func _on_texture_button_button_down() -> void:
	touchedUp = true
	pass # Replace with function body.

func _on_texture_button_button_up() -> void:
	touchedUp = false
	pass # Replace with function body.

var platform:PlatformWay
func _on_feet_detector_body_entered(body: Node2D) -> void:
	if (body is PlatformWay):
		platform = body
	pass # Replace with function body.


func _on_feet_detector_body_exited(body: Node2D) -> void:
	if (body is PlatformWay):
		platform = null
	pass # Replace with function body.
