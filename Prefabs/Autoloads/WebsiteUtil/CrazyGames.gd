extends BasePlatform


func Initializer():
	await CrazyGames.is_initialised_async()
	if (WebsiteUtil.platformType == WebsiteUtil.Platform.crazyGames):
		WebsiteUtil.SetCrazygamesSignals()

func StartSDK():
	CrazyGames.Game.gameplay_start()


func StopSDK():
	CrazyGames.Game.gameplay_stop()

func RequestMidgameAd() -> void:
	CrazyGames.ad.request_ad("midgame")

func play_ad_award() -> void:
	CrazyGames.ad.request_ad("rewarded")
