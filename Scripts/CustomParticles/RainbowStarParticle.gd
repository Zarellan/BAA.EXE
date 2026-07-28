extends Node2D
class_name RainbowStarParticle

@export var rainbowStar:PackedScene
@export var collisionPlace:CollisionShape2D

static var added:int = 0
var maxStars:int = 40

var spawnPlace:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	pass # Replace with function body.




func PlayRainbowStarParticle():
	if (GameHandler.saveDataSettings.quality != GameHandler.Quality.High):
		return
	for i in range(randi_range(3,8)):
		if (added >= maxStars):
			return
		var star = InstantiateUtil.Instantiate(rainbowStar, null)
		spawnPlace = Vector2(randf_range(collisionPlace.global_position.x - collisionPlace.shape.size.x / 2,\
		collisionPlace.global_position.x \
		+ collisionPlace.shape.size.x / 2),\
		randf_range(collisionPlace.global_position.y - collisionPlace.shape.size.y / 2,\
		collisionPlace.global_position.y \
		+ collisionPlace.shape.size.y / 2))
		star.position = Vector2(spawnPlace.x,spawnPlace.y)
		added += 1
