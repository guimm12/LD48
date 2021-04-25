extends KinematicBody2D

var speed : int = 18
var jumpForce : int = 300
var gravity : int = 1000

var vel : Vector2 = Vector2()

var isPaused = false

func sleep():
	isPaused = true

func wake():
	isPaused = false

func respawn():
	sleep()
	get_node("PlayerSprite").visible = false
	get_node("Particles2D").visible = false
	vel = Vector2(0, 0)
	self.transform = get_parent().get_node("Spawn").transform
	get_node("SpawnVortex").emitting = true
	yield(get_tree().create_timer(1.0), "timeout")
	get_node("SpawnVortex").emitting = false
	get_node("PlayerSprite").visible = true
	get_node("Particles2D").visible = true
	wake()

func die():
	respawn()

func _physics_process(delta):
	
	if isPaused:
		return
	
	# get inputs for this frame
	var pressed_left : bool = Input.is_action_pressed("left")
	var pressed_right : bool = Input.is_action_pressed("right")
	var just_pressed_jump : bool = Input.is_action_just_pressed("space")
	
	# general friction
	vel.x /= 1.2
	
	# movement inputs
	if not (get_which_wall_collided() == "right"):
		if pressed_left:
			if is_on_floor():
				vel.x -= speed
			else:
				vel.x -= speed/1.2
	if not (get_which_wall_collided() == "left"):
		if pressed_right:
			if is_on_floor():
				vel.x += speed
			else:
				vel.x += speed/1.2
	
	# applying the velocity
	vel = move_and_slide(vel, Vector2.UP)
	
	# gravity
	vel.y += gravity * delta
	
	# jump input
	if just_pressed_jump and is_on_floor():
		vel.y -= jumpForce+(vel.x*vel.x)/200
		vel.x *= 2
	
	# sprite direction
	if vel.x < 0 or get_which_wall_collided() == "left":
		get_node("PlayerSprite").flip_h = true
	elif vel.x > 0 or get_which_wall_collided() == "right":
		get_node("PlayerSprite").flip_h = false
	
	#
	if is_on_floor():
		$PlayerSprite.play("Idle")
	else:
		$PlayerSprite.play("Fall")

func get_which_wall_collided():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.normal.x > 0:
			return "left"
		elif collision.normal.x < 0:
			return "right"
	return "none"

func yeet():
	vel.x = 2000
