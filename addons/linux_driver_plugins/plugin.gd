@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	print("EditorPlugin loaded")
	if OS.get_name() == "Linux":
		ProjectSettings.set_setting("editor/run/main_run_args", "--rendering-driver opengl3")
	else:
		ProjectSettings.set_setting("editor/run/main_run_args", "")
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
