extends AudioStreamPlayer

func PlaySoundtrack(audio_path: String, vol_DB = 0.0,pit = 1.0):
	var audio = load(audio_path)
	if audio == null:
		push_error("no audio found on "+ audio_path)
		return
	stream = audio
	pitch_scale = pit
	volume_db = vol_DB
	play()
