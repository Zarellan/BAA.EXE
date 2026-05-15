extends AudioStreamPlayer


var current_DB = 0
func PlaySoundtrack(audio_path: String, vol_DB = 0.0,pit = 1.0):
	var audio = load(audio_path)
	if audio == null:
		push_error("no audio found on "+ audio_path)
		return
	stream = audio
	pitch_scale = pit
	current_DB = vol_DB
	volume_db = VolumeSettings(current_DB)
	play()

func ChangeVolumeSettings():
	volume_db = VolumeSettings(current_DB)

func VolumeSettings(volumeDB):
	var soundVol = clamp(SettingsScript.soundtrackVolume,0,100)
	
	if (soundVol == 0):
		return -80
	else:
		return volumeDB + 20.0 * log10M(soundVol/100.0)

func log10M(value):
	return log(value) / log(10)
