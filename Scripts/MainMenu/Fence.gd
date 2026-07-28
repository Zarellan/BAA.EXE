extends TextureRect
class_name Fence

@export var collision:TextureRect

func _ready() -> void:
	self_modulate.a = 0
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (!get_parent().visible):
		return
	position.x -= 300 * delta

	if position.x < 30:
		self_modulate.a -= 10 * delta
		if self_modulate.a <= 0.01:
			queue_free()
	else:
		if (self_modulate.a <= 1):
			self_modulate.a += 10 * delta
	pass
