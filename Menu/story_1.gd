extends MarginContainer

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://Menu/story_2.tscn")
