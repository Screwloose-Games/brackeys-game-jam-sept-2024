@tool
extends EditorPlugin

func _enter_tree():
  var settings = EditorInterface.get_editor_settings()
  # Use spaces with 2 spaces per block to see more code on GitHub and standardize indent width.
  settings.set_setting("text_editor/behavior/indent/type", 1)
  settings.set_setting("text_editor/behavior/indent/size", 2)
