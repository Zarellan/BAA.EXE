extends RichTextEffect
class_name PopEffect

var bbcode = "pop"
var time_appear = {}
var done_the_goal = {}
const DURATION := 0.15

func _process_custom_fx(char_fx):
	# animation progress
	if (!done_the_goal.has(char_fx.relative_index)):
		done_the_goal[char_fx.relative_index] = false
	if (done_the_goal[char_fx.relative_index]):
		return true
	if !time_appear.has(char_fx.relative_index):
		time_appear[char_fx.relative_index] = 0.0
	if time_appear[char_fx.relative_index] >= DURATION:
		char_fx.offset.y = 0
		done_the_goal[char_fx.relative_index] = true
		return true
	time_appear[char_fx.relative_index] += GameHandler.globalDelta
	# hidden/new char starts at 2
	# visible char lerps toward 0
	var t = clamp(time_appear[char_fx.relative_index] / 0.15, 0.0, 1.0)
	char_fx.offset.y = lerp(-5.0, 0.0, t)
	print("hello")
	return true
