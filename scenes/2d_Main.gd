extends Node2D

onready var prompt : RichTextLabel = $Control/Interaction_Prompt

func _ready():
	$Control/Transition_AnimationPlayer.play("FadeOut")
	
	$World/AnimationPlayer.play("TV")
	
	if not MetaManager.got_the_real_key:
		get_tree().paused = true
		$World/TV/TV_Area/CollisionShape2D.disabled = true
		$World/Key.visible = false
		yield(get_tree().create_timer(1.5), "timeout")
		$World/Key.visible = true
		get_tree().paused = false
		$World/Player_Plataformer.yeet()
		$World/Particles2D_explosion.emitting = true
		yield(get_tree().create_timer(.5), "timeout")
		$World/TV/TV_Area/CollisionShape2D.disabled = false

	if MetaManager.used_saw:
		$World/Tree.queue_free()

func _physics_process(delta):
	if not MetaManager.got_the_real_key:
		if Input.is_action_just_pressed("e"):
			if prompt.bbcode_text == "[wave][center][E] Cut[/center][/wave]":
				$World/Tree.queue_free()
				prompt.bbcode_text = ""
				$World/Key.visible = false
				MetaManager.used_saw = true
			if prompt.bbcode_text == "[wave][center][E] Push[/center][/wave]":
				prompt.bbcode_text = "[wave][center]You are not strong enough[/center][/wave]"
			if prompt.bbcode_text == "[wave][center][E] Turn on[/center][/wave]":
				prompt.bbcode_text = ""
				$World/Player_Plataformer.sleep()
				$World/Computer/AnimatedSprite.play("TurnOn")
				yield(get_tree().create_timer(1), "timeout")
				$World/Computer/AnimatedSprite.play("Loop")
				yield(get_tree().create_timer(1), "timeout")
				$World/AnimationPlayer.play("Computer_Transition")
				yield(get_tree().create_timer(1.5), "timeout")
				get_tree().change_scene("res://scenes/Race_Main.tscn")

func _on_KillZone_body_entered(body):
	if body.get_name() == "Player_Plataformer":
		body.sleep()
		body.die()

func _on_Spike_body_entered(body):
	if body.get_name() == "Player_Plataformer":
		body.sleep()
		body.die()

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player_Plataformer":
		$World/Key.has_been_picked_up()

func _on_TV_Area_body_entered(body):
	if body.get_name() == "Player_Plataformer":
		$World/AnimationPlayer2.play("TransitionBack")

func _on_AnimationPlayer2_animation_finished(anim_name):
	if anim_name == "TransitionBack":
		get_tree().change_scene("res://scenes/3d_Main.tscn")

func _on_Tree_Area2D_body_entered(body):
	if body.get_name() == "Player_Plataformer":
		if MetaManager.has_saw:
			prompt.bbcode_text = "[wave][center][E] Cut[/center][/wave]"
		else:
			prompt.bbcode_text = "[wave][center][E] Push[/center][/wave]"

func _on_Tree_Area2D_body_exited(body):
	if body.get_name() == "Player_Plataformer":
		prompt.bbcode_text = ""

func _on_ComputerArea2D_body_entered(body):
	if body.get_name() == "Player_Plataformer":
		if not MetaManager.got_the_real_key:
			prompt.bbcode_text = "[wave][center][E] Turn on[/center][/wave]"

func _on_ComputerArea2D_body_exited(body):
	if body.get_name() == "Player_Plataformer":
		prompt.bbcode_text = ""
