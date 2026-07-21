extends BasePlatform


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float):
	print("pr")
func Initializer():
	await CrazyGames.is_initialised_async()
	if (WebsiteUtil.platformType == WebsiteUtil.Platform.crazyGames):
		WebsiteUtil.SetCrazygamesSignals()

func StartSDK():
	CrazyGames.Game.gameplay_start()


func StopSDK():
	CrazyGames.Game.gameplay_stop()

func RequestMidgameAd() -> void:
	await CrazyGames.Ad.request_ad_async("midgame")

func play_ad_award() -> void:
	if !CrazyGames.is_initialised:
		print("CrazyGames SDK is not initialized yet!")
		WebsiteUtil._resume_game()
		return
	var result:Dictionary = await CrazyGames.Ad.request_ad_async("rewarded")

	if result["state"] == "finished":
		if WebsiteUtil._current_reward_callback.is_valid():
			WebsiteUtil._current_reward_callback.call()
	else:
		print("Ad was not finished. No reward given. Status: ", result)
	WebsiteUtil._current_reward_callback = Callable()
