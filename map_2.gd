extends Node2D

const SPEED = 150.0
var climbing = false

@onready var pl1 = $player1


func _physics_process(delta):
	if climbing == true:
		pl1.velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			print("up")
			pl1.velocity.y = -SPEED
		elif Input.is_action_pressed("ui_down"):
			print("down")
			pl1.velocity.y = SPEED
	


func _on_ladder_body_entered(body):
	climbing = true


func _on_ladder_body_exited(body):
	climbing = false
