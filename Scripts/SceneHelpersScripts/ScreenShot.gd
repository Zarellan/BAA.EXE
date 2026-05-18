extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SubViewportContainer/SubViewport.transparent_bg = true
	await RenderingServer.frame_post_draw
	var img = $SubViewportContainer/SubViewport.get_texture().get_image()
	img.save_png("res://ScreenShotPictures/image.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
