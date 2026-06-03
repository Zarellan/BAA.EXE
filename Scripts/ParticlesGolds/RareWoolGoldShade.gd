extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goldWoolValue = ValueSaver.new()
	GoldWool()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	get_parent().material.set_shader_parameter("progress", goldWoolValue.number)
	pass

var goldWoolTween:Tween

var goldWoolValue:ValueSaver


func GoldWool():
	goldWoolValue.number = 0
	goldWoolTween = TweenUtils.tweenNumber(self,goldWoolValue,1,0.9,TweenUtils.Ease.linear)
	goldWoolTween.finished.connect(GoldWool)
