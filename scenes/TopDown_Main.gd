extends Node2D

onready var prompt : RichTextLabel = $Control/Interaction_Prompt

func _ready():
	$World/Background.play("On")
	$World/End.play("Camera_Normal")
	$Control/Transition_AnimationPlayer.play("FadeOut")

func _physics_process(delta):
	if Input.is_action_just_pressed("e"):
		if prompt.bbcode_text == "[wave][center][E] Pick up[/center][/wave]":
			prompt.bbcode_text = "[wave][center]You got the key[/center][/wave]"
			MetaManager.got_the_real_key = true
			$World/Key.visible = false
			$player_topdown.visible = false
			$World/End.play("End")
			yield(get_tree().create_timer(2), "timeout")
			get_tree().change_scene("res://scenes/Return_Race_Main.tscn")

func _on_Key_Area2D_body_entered(body):
	if body.get_name() == "player_topdown":
		prompt.bbcode_text = "[wave][center][E] Pick up[/center][/wave]"

func _on_Key_Area2D_body_exited(body):
	if body.get_name() == "player_topdown":
		prompt.bbcode_text = ""
