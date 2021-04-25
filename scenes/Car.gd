extends KinematicBody2D

var velocity = Vector2()

func _ready():
	velocity.x = -230

func _physics_process(delta):
	move_and_slide(velocity)

func _on_CollisionArea_body_entered(body):
	if body.get_name() == "Player_Racing":
		body.die()
