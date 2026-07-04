extends Node
class_name DeviceCheckerUtil

static var is_phone : bool = OS.get_name() == "Android" || OS.get_name() == "iOS"

static func IsUsingPhone() -> bool:
	return is_phone
