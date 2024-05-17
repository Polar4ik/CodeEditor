extends Node

func _input(_e: InputEvent) -> void:
	if Input.is_action_just_pressed("open_file"):
		%DirSelected.show()
