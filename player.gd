extends CharacterBody2D
var lcv = 0
const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const jetpackvelo = -10000.0
var double_jumplock = 0
var wall_jump_lock = 0
var inertia = Vector2()
var into_crouch_idle = false
var in_crouch = false
var climbing = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var jetppacklock = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var p_HUD = get_tree().get_first_node_in_group("HUD")
@onready var coll = "res://player1.tscn::CapsuleShape2D_n0b4"
func _ready():
	#p_HUD.show()
	pass


func _physics_process(delta):
	
	if Input.is_action_pressed("ui_down"):
		if into_crouch_idle == false and in_crouch == false:
			into_crouch_idle = true
		
	if Input.is_action_just_released("ui_down"):
		into_crouch_idle = false
		in_crouch = false
		$CollisionShape2D.shape.height = 44
		$CollisionShape2D.position = Vector2(1, 1)
	
	if Input.is_action_just_pressed("G"):
		pass
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_just_pressed("ui_up"):
			if double_jumplock == 0:
				velocity.y = -350.0
				double_jumplock = 1
	if is_on_wall() and Input.is_action_just_pressed("ui_up") and wall_jump_lock == 0:
		velocity.y = -350.0
	"""jetpack"""
	if Input.is_action_just_pressed("space"):
		if jetppacklock <= 0:
			gravity = 0
			velocity.y = -300.0
			$Timer.start()
			jetppacklock += 3
			print(jetppacklock)
	if Input.is_action_just_released("space"):
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		$Timer.is_stopped()
	if is_on_floor():
		if double_jumplock > 0:
			double_jumplock = 0
			print(double_jumplock)
		if jetppacklock > 0:
			jetppacklock -= delta
			print(jetppacklock)
	if is_on_wall():
		if jetppacklock > 0:
			jetppacklock -= delta + delta
		print(jetppacklock)
	"""jetpack"""
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	update_animation(direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity += inertia
	move_and_slide()
	inertia.x = move_toward(inertia.x, 0, SPEED)
	
@onready var anim = $AnimatedSprite2D
func update_animation(direction):
	if not is_on_floor():  # Jumping
		anim.play("jump_")
	elif direction != 0:  # Walking
		anim.play("walk_")
		anim.flip_h = direction < 0  # Flip sprite if moving left
	elif into_crouch_idle == true:
		anim.play("into_crouch")
		await get_tree().create_timer(.3).timeout
		into_crouch_idle = false
		in_crouch = true
		$CollisionShape2D.shape.height = 31
		$CollisionShape2D.position = Vector2(0, -3)
		
		
	elif in_crouch == true:
		anim.play("crouch_idle")
			
	else:  # Idle
		anim.play("idle_")

func _on_timer_timeout():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _on_area_2d_body_entered(body):
	get_tree().reload_current_scene()
