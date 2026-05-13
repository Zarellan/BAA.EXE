extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



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
