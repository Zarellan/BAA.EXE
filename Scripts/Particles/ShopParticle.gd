extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	pass # Replace with function body.


func _on_finished() -> void:
	self.call_deferred("queue_free")
	pass # Replace with function body.
