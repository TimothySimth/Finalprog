extends CharacterBody2D
var lcv = 0
const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const jetpackvelo = -10000.0
var double_jumplock = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var jetppacklock = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var p_HUD = get_tree().get_first_node_in_group("HUD")

func _ready():
	#p_HUD.show()
	pass


func _physics_process(delta):
	if Input.is_action_just_pressed("G"):
		pass
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_just_pressed("ui_up"):
			if double_jumplock == 0:
				velocity.y = -350.0
				double_jumplock = 1
	if is_on_wall() and Input.is_action_just_pressed("ui_up"):
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
	if Input.is_action_just_pressed("W") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("A", "D")
	update_animation(direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
@onready var anim = $AnimatedSprite2D
func update_animation(direction):
	if not is_on_floor():  # Jumping
		anim.play("jump_")
	elif direction != 0:  # Walking
		anim.play("walk_")
		anim.flip_h = direction < 0  # Flip sprite if moving left
	else:  # Idle
		anim.play("idle_")

func _on_timer_timeout():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
