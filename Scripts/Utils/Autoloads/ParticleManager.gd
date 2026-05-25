extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func PlayParticleWarmup(particle: GPUParticles2D):
	var instance := particle.duplicate() as GPUParticles2D
	instance.global_position = Vector2(-9999,-9999)
	instance.amount = 1
	instance.emitting = true
	instance.finished.connect(instance.queue_free)
	get_tree().current_scene.add_child.call_deferred(instance)

func PlayParticleOv(particle: GPUParticles2D, count: int, force := false):
	if (GameHandler.saveData.quality == GameHandler.Quality.Low && !force):
		return
	var instance := particle.duplicate() as GPUParticles2D
	instance.global_position = particle.global_position
	instance.amount = count
	instance.emitting = true
	instance.finished.connect(instance.queue_free)
	get_tree().current_scene.add_child.call_deferred(instance)

func PlayParticle(particle, count):
	for i in range(count):
		particle.emit_particle(
			Transform2D(),
			Vector2.ZERO,
			Color.WHITE,
			Color.WHITE,
			0
		)

func PlayParticleTime(particle, count, timer = 1):
	for i in range(count):
		await get_tree().create_timer(timer).timeout
		particle.emit_particle(
			Transform2D(),	
			Vector2.ZERO,
			Color.WHITE,
			Color.WHITE,
			0
		)
