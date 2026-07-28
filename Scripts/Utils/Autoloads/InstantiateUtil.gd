extends Node

func AddAsTree(instance, safety):
	if !safety:
		get_tree().current_scene.add_child(instance)
	else:
		get_tree().current_scene.add_child.call_deferred(instance)


func AddAsParent(instance, parent, safety):
	if !safety:
		parent.add_child(instance)
	else:
		parent.add_child.call_deferred(instance)


func Instantiate(packed_scene: PackedScene, parent: Node, safety = true):
	if not packed_scene:
		push_error("no packscene exist")
		return null
	var instance = packed_scene.instantiate()
	if parent == null:
		AddAsTree(instance, safety)
	else:
		AddAsParent(instance, parent, safety)
	
	return instance

func AddInCurrentScene(child, safety = false):
	if (safety):
		get_tree().current_scene.add_child.call_deferred(child)
	else:
		get_tree().current_scene.add_child(child)

func InstantiateNode(node: Node, parent: Node, safety = true):
	if not node:
		push_error("no packscene exist")
		return null
	var instance = node.instantiate()
	if parent == null:
		AddAsTree(instance, safety)
	else:
		AddAsParent(instance, parent, safety)
	
	return instance
