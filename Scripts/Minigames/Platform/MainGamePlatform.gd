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

@export var sparkReviveParticle:GPUParticles2D

@export var reviveChoice:Control

var died = false

var imgLose:Image

var defaultSoundtrackDB:float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if (instance == null):
	instance = self # the class isn't singleton so it's better to always instance when loaded to this scene
	tweenScaleWool1 = TweenUtils.tweenScalePingPong(woolBarrier1,Vector2(0.95,1),Vector2(1.05,1),3.2,TweenUtils.Ease.InOutSine)
	tweenScaleWool2 = TweenUtils.tweenScalePingPong(woolBarrier2,Vector2(0.95,1),Vector2(1.05,1),3.2,TweenUtils.Ease.InOutSine)
	ParticleManager.PlayParticleWarmup(woolBarrier1Particle)
	ParticleManager.PlayParticleWarmup(woolBarrier2Particle)
	ParticleManager.PlayParticleWarmup(sparkReviveParticle)
	PlatformSpawner()
	died = false
	score = 0
	gameOverScreenTimer.timeout.connect(BringGameOverScreen)
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/PlatformMinigame.mp3")
	defaultSoundtrackDB = GlobalSoundtrack.volume_db
	modify_curve_domain()
	isPhone()
	ScreenShotGame()
	pass

func ScreenShotGame():
	var playero = get_tree().get_first_node_in_group("PlayerPlatform")
	var sizeRect = Vector2(750,550)
	var randomSmallPosition = Vector2(randf_range(-20,20),randf_range(-20,20))
	var player_screen_pos = playero.get_global_transform_with_canvas().origin
	var screenSize = get_viewport().get_visible_rect().size
	var targetVec:Vector2 = Vector2((randomSmallPosition.x + player_screen_pos.x) - (sizeRect.x/2), (randomSmallPosition.y + player_screen_pos.y)- (sizeRect.y/2))
	var clampedVec:Vector2 = Vector2(clamp(targetVec.x, 0, screenSize.x - sizeRect.x),clamp(targetVec.y, 0, screenSize.y - sizeRect.y))
	var region = Rect2i(int(clampedVec.x), int(clampedVec.y), sizeRect.x, sizeRect.y)

	var ui_canvas: CanvasLayer = $Control/CanvasLayer
	var original_canvas_rid = ui_canvas.get_canvas()
	
	RenderingServer.viewport_remove_canvas(get_viewport().get_viewport_rid(), original_canvas_rid)
	
	
	RenderingServer.force_draw(false)
	var image = get_viewport().get_texture().get_image()
	var cropped_image = image.get_region(region)
	
	RenderingServer.viewport_attach_canvas(get_viewport().get_viewport_rid(), original_canvas_rid)
	RenderingServer.viewport_set_canvas_stacking(get_viewport().get_viewport_rid(), original_canvas_rid, ui_canvas.layer, 0)
	imgLose =  cropped_image
	#var save_dir = "res://ScreenShotPictures/"
	#DirAccess.make_dir_absolute(save_dir)
	#var error = cropped_image.save_png(save_dir + "image2.png")
	#
	#if error == OK:
		#print("Screenshot saved via RenderingServer successfully!")
	#else:
		#print("Error saving screenshot: ", error)

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
	if (Input.is_action_just_pressed("Enter_Key")):
		Revive()
	#if (Input.is_action_just_pressed("ui_down")):
		#ScreenShotGame()
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
	height_ratio = clamp(height_ratio, (1-(600/GameHandler.TotalJumpPower()))*1.2, 1.0)
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
		GameHandler.UnlockSkin("Jump sheep")
	instance.textScore.scale = Vector2(randf_range(0.6,1.5),randf_range(0.6,1.5))
	TweenUtils.tweenScale(instance.textScore,Vector2.ONE,0.3,TweenUtils.Ease.OutCirc)
	pass


var twVolWp:Tween

@export var gameoverUI:Control
@export var loseTexture:TextureRect
@export var blackoutTexture:TextureRect
@export var retryButton:Control
@export var quitButton:Control
@export var gameOverScreenTimer:Timer

func Revive():
	WebsiteUtil.StartSDK()
	RemoveReviveBox(true)
	TweenUtils.StopTween(twVolWp)
	TweenUtils.StopTween(audioFallVolumeTween)
	audioFall.queue_free()
	if (DeviceCheckerUtil.IsUsingPhone()):
		for i in range(phoneButtons.size()):
			TweenUtils.tweenAlphaSelf(phoneButtons,1,0.3,TweenUtils.Ease.linear)
	twVolWp = TweenUtils.tweenCustom(self, 0.3, 1, 0.5, TweenUtils.Ease.linear, func(val): 
		GlobalSoundtrack.pitch_scale = val)
	TweenUtils.tweenCustom(self, -80, defaultSoundtrackDB, 0.5, TweenUtils.Ease.linear, func(val): 
		GlobalSoundtrack.volume_db = val
		)
	var playero:PlayerPlatform = get_tree().get_first_node_in_group("PlayerPlatform")
	var platformRev = InstantiateUtil.Instantiate(platformPrefab,self)
	playero.stomped = false
	platformRev.position = Vector2(CalculateBasedOfZoomXrng(),camera.position.y + 600)
	(platformRev as PlatformWay).platformType = PlatformWay.Type.revive
	TweenUtils.tweenY(platformRev,camera.position.y + 150,0.3,TweenUtils.Ease.OutCirc).finished.connect(func():
		await get_tree().create_timer(0.2).timeout
		playero.temporaryExtraJump += 200 # you get more power, me get more money
		playero.JUMP_VELOCITY = -GameHandler.TotalJumpPower() - playero.temporaryExtraJump
		playero.xPow = 0
		playero.velocity = Vector2(0,0)
		playero.jumpVector = Vector2(0,0)
		playero.activeGravity = false
		playero.global_position = platformRev.global_position - Vector2(0,75)
		sparkReviveParticle.global_position = playero.global_position
		ParticleManager.PlayParticleOv(sparkReviveParticle,randi_range(15,25))
		var audioTelep = GlobalAudio.PlayOneShot("res://Sounds/teleport.mp3",8)
		audioTelep.seek(0.3)
		TweenUtils.tweenCustom(self,1,0,0.4,TweenUtils.Ease.linear,func(val):
			playero.sprite.get_node("SheepBright").material.set_shader_parameter("flash_modifier",val))
		(camera as CameraShake).add_trauma(0.25)
		await get_tree().create_timer(0.5).timeout
		playero.activeGravity = true
		died = false
	)
	revivedCount += 1
var revivedCount:int = 0
var audioFall:AudioStreamPlayer
var audioFallVolumeTween:Tween
func GameOver():
	if (died):
		return
	WebsiteUtil.StopSDK()
	if (DeviceCheckerUtil.IsUsingPhone()):
		for i in range(phoneButtons.size()):
			TweenUtils.tweenAlphaSelf(phoneButtons,0,0.3,TweenUtils.Ease.linear)
	twVolWp = TweenUtils.tweenCustom(self, 1, 0.3, 2, TweenUtils.Ease.linear, func(val): 
		GlobalSoundtrack.pitch_scale = val)
	twVolWp.finished.connect(func():
			twVolWp = TweenUtils.tweenCustom(self, defaultSoundtrackDB, -80, 4, TweenUtils.Ease.linear, func(val): 
				GlobalSoundtrack.volume_db = val))
	audioFall = GlobalAudio.PlayOneShot("res://Sounds/falling.mp3",-3)
	audioFallVolumeTween = TweenUtils.tweenCustom(self,-3,-80,10,TweenUtils.Ease.linear,func(val):
		audioFall.volume_db = val)
	if (GameHandler.saveDataAchievements.platformMinigameScore < score):
		GameHandler.saveDataAchievements.platformMinigameScore = score
	died = true
	await get_tree().create_timer(0.4).timeout
	if (WebsiteUtil.adSupport && revivedCount < 1):
		ReviveBox()
	else:
		BringGameOver()
	pass
@export var progressReviveBar:ProgressBar
var tweenRevive:Tween
var tweenRevealChoice:Tween
var canReviveButton:bool = false
func ReviveBox():
	canReviveButton = true
	reviveChoice.visible = true
	tweenRevealChoice = TweenUtils.tweenY(reviveChoice,0,0.3,TweenUtils.Ease.OutCirc)
	tweenRevive = TweenUtils.tweenCustom(self,1.0,-0.2,5,TweenUtils.Ease.linear,func(val):
		progressReviveBar.value = val)
	tweenRevive.finished.connect(RemoveReviveBox)
func RemoveReviveBox(reviveSuccess:bool = false):
	canReviveButton = false
	TweenUtils.StopTween(tweenRevealChoice)
	TweenUtils.StopTween(tweenRevive)
	tweenRevealChoice = TweenUtils.tweenY(reviveChoice,-1280,0.3,TweenUtils.Ease.InSine)
	tweenRevealChoice.finished.connect(func():
		reviveChoice.visible = false)
	if (!reviveSuccess):
		BringGameOver(0.5)

func BringGameOver(timer:float = 1.7):
	gameoverUI.visible = true
	gameOverScreenTimer.start(timer)
	
	GameHandler.SaveAllDataGlob()

func BringGameOverScreen():
	TweenUtils.tweenAlphaSelf(blackoutTexture,0.4,0.3,TweenUtils.Ease.linear)
	StartPositionTextureGameOver(loseTexture.get_parent())
	var durationPos:float = randf_range(0.7,1.3)
	TweenUtils.tweenX(loseTexture.get_parent(),randf_range(312.0,417.0),durationPos,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(loseTexture.get_parent(),randf_range(32.0,113.0),durationPos,TweenUtils.Ease.OutCirc)
	var rotMost:float = randf_range(-15,15)
	while (rotMost < 9 && rotMost > -9):
		rotMost = randf_range(-15,15)
	TweenUtils.tweenRotation(loseTexture.get_parent(),rotMost,durationPos,TweenUtils.Ease.OutCirc)
	loseTexture.texture = ImageTexture.create_from_image(imgLose)
	TweenUtils.tweenY(textScore,462,1.1,TweenUtils.Ease.OutCirc)
	retryButton.rotation_degrees = ReturnRandomWithLimit(-25,25,-12,-12)
	quitButton.rotation_degrees = ReturnRandomWithLimit(-25,25,-12,-12)
	TweenUtils.tweenY(retryButton,529.0,0.6,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenY(quitButton,529.0,0.6,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenRotation(retryButton,0,0.6,TweenUtils.Ease.OutCirc)
	TweenUtils.tweenRotation(quitButton,0,0.6,TweenUtils.Ease.OutCirc)

func ReturnRandomWithLimit(min,max,minLimit,maxLimit):
	var num:float = randf_range(min,max)
	while (num < maxLimit && num > minLimit):
		num = randf_range(min,max)
	return num

func StartPositionTextureGameOver(textureNode:Control):
	if randi_range(1,2) == 1:
		textureNode.position.x = randf_range(-612.0,-569.0)
	else:
		textureNode.position.x = randf_range(1306.0,1420.0)
	textureNode.position.y = randf_range(27.0,112.0)


func _on_retry_pressed() -> void:
	TransitionScript.ReloadScene()
	Changing()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	TransitionScript.ChangeScene("res://Scenes/MainFarm.tscn",SceneChangedFromMinigame)
	if (GameHandler.saveDataAchievements.platformMinigameScore < score):
		GameHandler.saveDataAchievements.platformMinigameScore = score
	GameHandler.SaveAllDataGlob()
	Changing()
	pass # Replace with function body.

func Changing():
	TweenUtils.StopTween(twVolWp)
	GlobalSoundtrack.volume_db = -80
	GlobalSoundtrack.pitch_scale = 1

func SceneChangedFromMinigame():
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/lesiakower-morning-coffee-396750.mp3")
	GlobalSoundtrack.pitch_scale = 1
	GlobalSoundtrack.volume_db = -80


func _on_giveup_pressed() -> void:
	if (canReviveButton):
		RemoveReviveBox()
	pass # Replace with function body.


func _on_revive_pressed() -> void:
	if (canReviveButton):
		WebsiteUtil.play_ad_award(func():
			Revive())
	pass # Replace with function body.
