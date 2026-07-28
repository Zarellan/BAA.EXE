@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


var button: Button = Button.new()

func _enter_tree():
	button.text = "Indent"

	button.pressed.connect(_indent)

	add_control_to_container(
		CONTAINER_TOOLBAR,
		button
	)
	var parent = button.get_parent()
	if parent:
		parent.move_child(button, 5)


func _exit_tree():
	remove_control_from_container(
		CONTAINER_TOOLBAR,
		button
	)

	button.queue_free()

func _indent():
	var script_editor = get_editor_interface().get_script_editor()
	var editor = script_editor.get_current_editor()

	if not editor:
		return

	var code_edit = editor.get_base_editor()

	if code_edit:
		code_edit.indent_lines()
