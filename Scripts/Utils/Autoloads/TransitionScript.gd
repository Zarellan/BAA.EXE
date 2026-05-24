extends Control


var materialValue:ValueSaver

func ChangeScene(sceneFile:String):
	get_tree().change_scene_to_file(sceneFile)
