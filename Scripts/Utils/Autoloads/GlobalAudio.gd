extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func PlayOneShot(audio_path: String, vol_DB = 0,pit = 1):
	
	var pl = AudioStreamPlayer.new()
	add_child(pl)
	if audio_path.ends_with(".ogg"):
		pl.stream = AudioStreamOggVorbis.load_from_file(audio_path)
	else:
		pl.stream = AudioStreamMP3.load_from_file(audio_path)
	pl.pitch_scale = pit
	pl.volume_db = vol_DB
	pl.finished.connect(func():
		pl.queue_free())
	pl.play()
