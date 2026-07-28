extends TextureRect

@export var fence:PackedScene
var motion:Vector2

var jumped:bool = false

var spawnTime:float = 0

var fenceRec:TextureRect

var gotHit:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fenceRec = InstantiateUtil.Instantiate(fence,get_parent()) as TextureRect
	spawnTime = 0
	pass # Replace with function body.

var fenceRect: Rect2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!get_parent().visible):
		return
	var sheepRect:Rect2 = get_global_rect()
	if (is_instance_valid(fenceRec)):
		fenceRect = (fenceRec as Fence).collision.get_global_rect()
	spawnTime += delta
	position.y += motion.y * delta
	Gravity(delta)
	if !jumped && (Input.is_action_pressed("ui_accept") || Input.is_action_pressed("ui_up") || Input.is_action_pressed("LeftMouse")):
		motion.y = -1500
		jumped = true
		pass
	fenceSpawner()
	if (is_instance_valid(fenceRec)):
		if (sheepRect.intersects(fenceRect)):
			fenceRec.queue_free()
			fenceRect = Rect2()
			gotHit = true
	SheepHurt(delta)
	SheepAnimation(delta)
	pass

var coolDown:float = 0
func SheepHurt(delta):
	if (gotHit):
		coolDown += delta
		if (coolDown >= 1.50):
			self_modulate.a = 1
			gotHit = false
		elif (coolDown >= 1.20):
			self_modulate.a = 1
		elif (coolDown >= 0.90):
			self_modulate.a = 0.3
		elif (coolDown >= 0.60):
			self_modulate.a = 1
		elif (coolDown >= 0.30):
			self_modulate.a = 0.3
		elif (coolDown >= 0):
			self_modulate.a = 0.3
	else:
		coolDown = 0
func Gravity(delta):
	if position.y < -36:
		motion.y += 5000 * delta
	else:
		motion.y = 0
		position.y = -36
		jumped = false

var animationFrames:float = 0
func SheepAnimation(delta):
	if (jumped):
		texture.region.position.x = 16
		animationFrames = 0
		return
	animationFrames += delta
	if (animationFrames >= 0.6):
		animationFrames = 0
	elif (animationFrames >= 0.3):
		texture.region.position.x = 16
	elif (animationFrames >= 0):
		texture.region.position.x = 0
func fenceSpawner():
	if (spawnTime >= 3):
		fenceRec = InstantiateUtil.Instantiate(fence,get_parent()) as TextureRect
		spawnTime = 0
