extends Node # responsible for SDK websites


enum Platform
{
	none,
	crazyGames
}

var gameStarted:bool = false
var _current_reward_callback: Callable = Callable()

var rewardBased:bool = false

var platformType:Platform = Platform.none

var platformMain

var adSucceed

var caughtError:bool = false
func _ready() -> void:
	BuildType()
	process_mode = Node.PROCESS_MODE_ALWAYS
	Initializer()

func SetCrazygamesSignals():
	CrazyGamesBridge.callbacks.ad_started.connect(_on_ad_started)
	CrazyGamesBridge.callbacks.ad_finished.connect(_on_ad_finished)
	CrazyGamesBridge.callbacks.ad_error.connect(_on_ad_error)

func BuildType():
	if (OS.has_feature("CrazyGames")):
		platformType = Platform.crazyGames
		platformMain = load("res://Prefabs/Autoloads/WebsiteUtil/CrazyGames.gd").new()
	else:
		platformType = Platform.none
		platformMain = load("res://Prefabs/Autoloads/WebsiteUtil/BasePlatform.gd").new()
	platformMain.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(platformMain)

func Initializer():
	platformMain.Initializer()

func StartSDK():
	if (gameStarted):
		return
	print("start")
	platformMain.StartSDK()
	gameStarted = true


func StopSDK():
	if (!gameStarted):
		return
	platformMain.StopSDK()
	gameStarted = false




## Call this during natural breaks (player death, level change, match over)
func RequestMidgameAd() -> void:
	if (platformType == Platform.none):
		return
	caughtError = false
	platformMain.RequestMidgameAd()

# =============================================================================
# SDK CALLBACKS (PAUSE & RESUME MAPPING)
# =============================================================================

func play_ad_award(funct: Callable) -> void:
	if (platformType == Platform.none):
		if (OS.has_feature("editor")):
			funct.call()
		return
	# Save the function reference so we can call it when the ad completes
	_current_reward_callback = funct
	rewardBased = true
	caughtError = false
	platformMain.play_ad_award()

func _on_ad_started() -> void:
	if (caughtError):
		print("error found, don't play the ad without reason")
		return
	
	# Mute all game sound instantly
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	# Pause the entire game tree
	get_tree().paused = true


func _on_ad_finished() -> void:
	print("✅ Ad completed successfully.")
	_resume_game()
	#
	#if (rewardBased):
		#if (adSucceed == "finished"):
			#_current_reward_callback.call()
		#rewardBased = false
	#_current_reward_callback = Callable()

@warning_ignore("unused_parameter")
func _on_ad_error(error_code) -> void:
	#_current_reward_callback = Callable()
	get_tree().paused = false
	caughtError = true
	_resume_game()


func _resume_game() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	get_tree().paused = false
