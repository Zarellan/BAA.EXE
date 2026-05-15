extends Node
class_name DeviceCheckerUtil



static func IsUsingPhone() -> bool:
	return OS.get_name() == "Android" || OS.get_name() == "iOS"
