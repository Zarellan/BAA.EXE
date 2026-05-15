extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func PlayParticleOv(particle, count):
	var instance = particle.duplicate()
	instance.global_position = particle.global_position
	(instance as GPUParticles2D).amount = count
	(instance as GPUParticles2D).emitting = true
	(instance as GPUParticles2D).finished.connect(instance.queue_free)
	get_tree().current_scene.add_child.call_deferred(instance)
	
func PlayParticleTimeOv(particle, count, timer = 1):
	var instance = particle.duplicate()
	instance.global_position = particle.global_position
	(instance as GPUParticles2D).amount = count
	(instance as GPUParticles2D).emitting = true
	(instance as GPUParticles2D).finished.connect(instance.queue_free)
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
