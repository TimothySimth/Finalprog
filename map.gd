extends Node2D

const SPEED = 150.0
var lcv = 0
var climbing = false

@onready var pl1 = $player1
@onready var canvas = $CanvasModulate
@onready var YourSprite = $CPUParticles2D2

func _physics_process(delta):
	if climbing == true:
		pl1.velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			print("up")
			pl1.velocity.y = -SPEED
		elif Input.is_action_pressed("ui_down"):
			print("down")
			pl1.velocity.y = SPEED
	if Input.is_action_just_pressed("r"):
		YourSprite.visible = not YourSprite.visible
		canvas.visible = not canvas.visible
	pass
	



func _on_mo_body_entered(body):
	climbing = true
	var p = 0


func _on_mo_body_exited(body):
	climbing = false
