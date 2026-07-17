extends Node # responsible for SDK websites

var gameStarted:bool = false
var _current_reward_callback: Callable = Callable()

var rewardBased:bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	CrazyGamesBridge.callbacks.ad_started.connect(_on_ad_started)
	CrazyGamesBridge.callbacks.ad_finished.connect(_on_ad_finished)
	CrazyGamesBridge.callbacks.ad_error.connect(_on_ad_error)

func Initializer():
	print("Checking CrazyGames SDK...")
	
	# 1. Wait for the asynchronous initialization sequence to complete
	await CrazyGames.is_initialised_async()
	
	# 2. Check if it succeeded
	if CrazyGames.is_initialised:
		print("🎉 CrazyGames SDK successfully initialized!")
		# It is now safe to show banners, trigger ads, or load user data
	else:
		print("⚠️ SDK is not initialized. (Normal behavior if running in desktop editor)")

func StartSDK():
	if (gameStarted):
		return
	print("start")
	CrazyGames.Game.gameplay_start()
	gameStarted = true



func StopSDK():
	if (!gameStarted):
		return
	print("stop")
	CrazyGames.Game.gameplay_stop()
	gameStarted = false




## Call this during natural breaks (player death, level change, match over)
func RequestMidgameAd() -> void:
	print("Requesting midgame ad break...")
	CrazyGames.ad.request_ad("midgame")

# =============================================================================
# SDK CALLBACKS (PAUSE & RESUME MAPPING)
# =============================================================================

func play_ad_award(funct: Callable) -> void:
	print("Requesting a rewarded ad...")
	
	# Save the function reference so we can call it when the ad completes
	_current_reward_callback = funct
	rewardBased = true
	# Fire the SDK rewarded ad request
	CrazyGames.ad.request_ad("rewarded")

func _on_ad_started() -> void:
	print("🎬 Ad started rendering. Freezing gameplay loops.")
	
	# Mute all game sound instantly
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	
	# Pause the entire game tree
	get_tree().paused = true


func _on_ad_finished() -> void:
	print("✅ Ad completed successfully.")
	_resume_game()
	
	if (rewardBased):
		_current_reward_callback.call()
		rewardBased = false
	_current_reward_callback = Callable()


func _on_ad_error(error_code: String) -> void:
	print("❌ Ad failed or went on cooldown. Error: ", error_code)
	rewardBased = false
	_current_reward_callback = Callable()
	# CRITICAL: Always resume the game even if an ad fails, otherwise players lock up
	_resume_game()


func _resume_game() -> void:
	print("▶️ Resuming gameplay and audio.")
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	get_tree().paused = false
