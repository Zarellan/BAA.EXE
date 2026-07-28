extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().transparent_bg = true
	await RenderingServer.frame_post_draw
	var img = get_viewport().get_texture().get_image()
	img.save_png("res://ScreenShotPictures/Full/image.png")
	#TransitionScript.ChangeScene("res://Scenes/MainFarm.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
