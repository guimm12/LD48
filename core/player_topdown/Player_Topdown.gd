extends KinematicBody2D

var speed = 80
var friction = 0.2
var acceleration = 0.5
var velocity = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func get_inputs():
	var input_velocity = Vector2.ZERO

	# Movement Input
	if Input.is_action_pressed("right"):
		input_velocity.x += 1
	if Input.is_action_pressed("left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("down"):
		input_velocity.y += 1
	if Input.is_action_pressed("up"):
		input_velocity.y -= 1
	input_velocity = input_velocity.normalized() * speed

	return input_velocity

func _physics_process(delta):
	var input_velocity = get_inputs()

	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
