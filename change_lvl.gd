extends Area2D



func _on_body_entered(body):
	if body.is_in_group("player"):
		var lvl = "res://map_2.tscn"
		get_tree().change_scene_to_file(lvl)
