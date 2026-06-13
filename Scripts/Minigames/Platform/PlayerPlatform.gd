extends CharacterBody2D


const rotationSpeed = 2
const JUMP_VELOCITY = -700.0

var jump_angle: float = 0.0
var xPow = 0
var jumpVector:Vector2 = Vector2.ZERO

var jumped = true

@export var anchorArrow:Marker2D
@export var camera:Camera2D
@export var sprite:Sprite2D

var skewTween:Tween
func _physics_process(delta: float) -> void:
	anchorArrow.position = $Sprite2D/Nodo.global_position
	#print(get_viewport_rect().size.x * camera.zoom.x)
	#print(camera.position.x + (get_viewport_rect().size.x * camera.zoom.x / 2))
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = -jumpVector.x
		anchorArrow.visible = false
	else:
		velocity.x = 0
		anchorArrow.visible = true
		if (jumped):
			TweenUtils.tweenY(camera,position.y - 100,0.5,TweenUtils.Ease.OutCirc)
			sprite.scale = Vector2(1.1,0.6)
			TweenUtils.tweenScale(sprite,Vector2(1,1),0.5,TweenUtils.Ease.OutCirc)
			skewTween = TweenUtils.tweenSkewPingPong(sprite,deg_to_rad(-10),deg_to_rad(10),0.4,TweenUtils.Ease.InOutSine)
		jumped = false
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumped = true
		sprite.scale = Vector2(0.8,1.3)
		TweenUtils.tweenScale(sprite,Vector2(1,1),0.5,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(skewTween)
		TweenUtils.tweenSkew(sprite,deg_to_rad(0),0.4,TweenUtils.Ease.OutCirc)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		# 1. CONSTANT ROTATION: Change the angle at a fixed rate over time
		jump_angle += direction * rotationSpeed * delta
		
		# Optional: Clamp the angle so the player can't aim into the ground
		jump_angle = clamp(jump_angle, deg_to_rad(-75), deg_to_rad(75))
		
		# 2. CALCULATE VECTOR: Convert the angle into an X and Y launch force
		# Vector2.UP is (0, -1). We rotate it by our jump_angle, then multiply by launch force.
		jumpVector = Vector2.UP.rotated(jump_angle) * JUMP_VELOCITY
		
		# 3. APPLY TO ARROW VISUAL
		anchorArrow.rotation = jump_angle# --- ARROW ROTATION LOGIC ---
	if is_on_floor():
		# angle() calculates the exact angle of a Vector2. 
		# We use xPow for horizontal, and JUMP_VELOCITY for vertical preview.
		var jump_vector = Vector2(xPow, JUMP_VELOCITY)
		anchorArrow.rotation = jumpVector.angle() - deg_to_rad(90)
	move_and_slide()


func _on_wool_barrier_collision_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("PlayerPlatform")):
		return
	if (jumpVector.x > 0):
		jumpVector.x = -jumpVector.x
	pass # Replace with function body.


func _on_wool_barrier_collision_2_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("PlayerPlatform")):
		return
	if (jumpVector.x < 0):
		jumpVector.x = -jumpVector.x
	pass # Replace with function body.
