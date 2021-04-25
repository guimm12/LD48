extends KinematicBody2D

var velocity = Vector2()

func _ready():
	velocity.x = -230
	$TV_AnimationPlayer.play("TvOff")
	$TV_Transition_AnimationPlayer.play("Camera_Normal")

func _physics_process(delta):
	move_and_slide(velocity)


func _on_TV_Area_body_entered(body):
	if body.get_name() == "Player_Racing":
		body.hit_tv()
		$SmokeTV1.emitting = true
		$SmokeTV2.emitting = true
		$SmokeTV3.emitting = true
		$TV_AnimationPlayer.play("TruckTvStatic")
		$TV_Transition_AnimationPlayer.play("TV_Truck_Transition")


func _on_TV_Transition_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "TV_Truck_Transition":
		get_tree().change_scene("res://scenes/TopDown_Main.tscn")
