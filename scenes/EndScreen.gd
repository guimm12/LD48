extends Node2D


func _ready():
	$Control/Transition_AnimationPlayer.play("FadeOut")
	yield(get_tree().create_timer(.1), "timeout")
	$Control/Interaction_Prompt.visible = true
