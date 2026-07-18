class_name BasePlatform
extends Node

func Initializer() -> void:
	pass

func StartSDK() -> void:
	pass

func StopSDK() -> void:
	pass

func request_midgame_ad() -> void:
	pass

func play_rewarded_ad(callback: Callable) -> void:
	# Default editor fail-safe: instantly reward the player
	callback.call()
