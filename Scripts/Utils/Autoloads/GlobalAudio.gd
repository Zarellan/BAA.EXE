extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func PlayOneShot(audio_path: String, vol_DB = 0.0,pit = 1.0):
	
	var audio = load(audio_path)
	if audio == null:
		push_error("no audio found on "+ audio_path)
		return
	var pl = AudioStreamPlayer.new()
	add_child(pl)
	pl.stream = audio
	pl.pitch_scale = pit
	pl.volume_db = vol_DB
	pl.finished.connect(pl.queue_free)
	pl.play()
