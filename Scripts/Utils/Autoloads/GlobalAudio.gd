extends AudioStreamPlayer

var current_DB = 0

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
	pl.volume_db = VolumeSettings(vol_DB)
	pl.finished.connect(pl.queue_free)
	pl.play()

func VolumeSettings(vol_DB):
	var soundVol = clamp(SettingsScript.audioVolume,0,100)
	
	if (soundVol == 0):
		return -80
	else:
		return vol_DB + 20.0 * log10M(soundVol/100.0)

func log10M(value):
	return log(value) / log(10)
