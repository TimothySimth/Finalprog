extends CharacterBody2D

var animfinish = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	pass












func _on_animated_sprite_2d_animation_finished():
	animfinish = true
