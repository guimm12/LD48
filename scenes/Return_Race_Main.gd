extends Node2D

func _ready():
	$Control/Transition_AnimationPlayer.play("FadeOut")
	yield(get_tree().create_timer(6), "timeout")
	$Control/Transition_AnimationPlayer.play("FadeIn")
	$Statics.visible = false
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/Return_2d_Main.tscn")
	

