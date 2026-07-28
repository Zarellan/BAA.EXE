extends Node2D

var materialLight:ShaderMaterial
var lightNode:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lightNode = get_node("FakeLight")
	lightNode.material = lightNode.material.duplicate()
	materialLight = lightNode.material
	materialLight.set_shader_parameter("radius", randf_range(0.2,0.3))
	set_process(false)
	set_physics_process(false)
	pass # Replace with function body.
