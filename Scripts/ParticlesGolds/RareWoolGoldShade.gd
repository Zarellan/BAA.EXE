extends Node2D

var parent:Node2D
var dupMaterial:ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goldWoolValue = ValueSaver.new()
	parent = get_parent()
	GoldWool()
	dupMaterial = parent.material.duplicate()
	parent.material = dupMaterial
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	dupMaterial.set_shader_parameter("progress", goldWoolValue.number)
	pass

var goldWoolTween:Tween

var goldWoolValue:ValueSaver


func GoldWool():
	goldWoolValue.number = 0
	goldWoolTween = TweenUtils.tweenNumber(self,goldWoolValue,1,0.9,TweenUtils.Ease.linear)
	goldWoolTween.finished.connect(GoldWool)
