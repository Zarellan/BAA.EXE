extends Node2D
class_name StarSpawner

@export var starInstance:PackedScene
@export var numberStarsSpawn:int
@export var numberStarsSpawnLow:int

var starsPack:Array[Node2D]
var spawnLuck = 0.50
var spawned = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SpawnStars()
	pass # Replace with function body.

func SpawnStars():
	var maxSpawn = numberStarsSpawn if (GameHandler.saveData.quality == GameHandler.Quality.High) else numberStarsSpawnLow
	for rem in range(starsPack.size() - 1,-1,-1):
		starsPack[rem].queue_free()
	starsPack.clear()
	spawnLuck = 0.50
	spawned = 0
	for y in range(-316.0,200,28):
		for x in range(-600,600,28):
			if (maxSpawn < spawned):
				break
			if (spawnLuck > randf_range(0.0,1.0)):
				var ins = InstantiateUtil.Instantiate(starInstance,self)
				ins.position = Vector2(x,y)
				starsPack.append(ins)
				spawned += 1
				spawnLuck = 0
			else:
				spawnLuck += 0.001
		if (maxSpawn < spawned):
				break
	pass # Replace with function body.
