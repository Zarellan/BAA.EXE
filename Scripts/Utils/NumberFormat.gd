extends Node
class_name NumberFormat


static var symbols = ["","k","M", "B", "T"]

static func Format(num:int):
	@warning_ignore("integer_division")
	return str(floor(num / (1 * pow(1000,(str(abs(num)).length()-1)/3)) * 100) / 100) + symbolHelp(int((str(abs(num)).length()-1)/3));

static func symbolHelp(index:int):
	@warning_ignore("integer_division")
	var symbol1 = char(97 + floor((index - 5) / 26))
	var symbol2 = char(97 + (index - 5) % 26)
	if (index < 5):
		return symbols[index]
	else:
		return str(symbol1) + str(symbol2)
