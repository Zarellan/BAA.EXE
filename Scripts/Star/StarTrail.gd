extends Sprite2D

@export var startFrom:float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var startTime:float = 0
var lastPositionX:float = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	startTime += delta
	position = Vector2(cos(startFrom + startTime * 5) * 150,-450 + (sin(startFrom + startTime * 5) * 30))
	
	if (lastPositionX - position.x >= 0.01):
		z_index = 2
		get_node("Trail").z_index = 1
	else:
		z_index = 0
		get_node("Trail").z_index = 0
	lastPositionX = position.x
	trail(delta)
	pass

var trailArray:Array
var maxTrail = 20
var starInterval:float = 0
func trail(delta):
	if (GameHandler.saveDataSettings.quality != GameHandler.Quality.High):
		return
	starInterval += delta
	if (starInterval <= 0.01):
		return
	else:
		starInterval = 0.0
	trailArray.push_front(global_position)
	
	if (trailArray.size() > maxTrail):
		trailArray.pop_back()
	get_node("Trail").clear_points()
	for point in trailArray:
		get_node("Trail").add_point(point)
	await get_tree().create_timer(0.5).timeout 
