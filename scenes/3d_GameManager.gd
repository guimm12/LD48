extends Spatial

onready var prompt : RichTextLabel = $Control/Interaction_Prompt

var hasBatteries = false
var tvOn = false
var doorOpen = false

func _ready():
	$Room/TV/Camera.current = false
	$Control/TransitionSprite.modulate.a = 0
	$Room/TV/TV_AnimationPlayer.play("TV_off")
	$Control/Transition_AnimationPlayer.play("FadeOut")
	if MetaManager.has_saw:
		$Room/Room_Model/left_texture.frame = 4
	if MetaManager.has_batteries:
		$Room/Batteries.visible = false
		hasBatteries = true
	
	if MetaManager.got_the_real_key:
		$Room/TV/TV_AnimationPlayer.play("Static")
	
	$Room/Doll/Sprite3D.frame = 0
	if MetaManager.entered_tv_once:
		$Room/Doll/Sprite3D.frame = 1
	if MetaManager.got_the_real_key:
		$Room/Doll/Sprite3D.frame = 3
		
func _physics_process(delta):
	if Input.is_action_just_pressed("e"):
		if prompt.bbcode_text == "[wave][center][E] Open[/center][/wave]":
			if not MetaManager.got_the_real_key:
				prompt.bbcode_text = "[wave][center]It's locked[/center][/wave]"
			else:
				prompt.bbcode_text = "[wave][center][E] Leave[/center][/wave]"
				$Room/Room_Model/front_texture.frame = 2
				doorOpen = true
			return
		if prompt.bbcode_text == "[wave][center][E] Turn off[/center][/wave]":
			prompt.bbcode_text = "[wave][center][E] Turn on[/center][/wave]"
			tvOn = false
			$Room/TV/TV_AnimationPlayer.play("TV_off")
			return
		if prompt.bbcode_text == "[wave][center][E] Turn on[/center][/wave]":
			if hasBatteries:
				if MetaManager.entered_tv_once:
					prompt.bbcode_text = ""
					$Room/TV/TV_AnimationPlayer.play("Static")
					$Room/TV/TV_AnimationPlayer2.play("TV_Transition")
					return
				else:
					prompt.bbcode_text = "[wave][center][E] Use batteries[/center][/wave]"
			else:
				prompt.bbcode_text = "[wave][center][E] Turn off[/center][/wave]"
			tvOn = true
			$Room/TV/TV_AnimationPlayer.play("LowBatteries")
			return
		if prompt.bbcode_text == "[wave][center][E] Pick up[/center][/wave]":
			prompt.bbcode_text = ""
			$Room/Batteries.visible = false
			hasBatteries = true
			MetaManager.has_batteries = true
			return
		if prompt.bbcode_text == "[wave][center][E] Use batteries[/center][/wave]":
			prompt.bbcode_text = ""
			$Room/TV/TV_AnimationPlayer.play("Static")
			$Room/TV/TV_AnimationPlayer2.play("TV_Transition")
			MetaManager.entered_tv_once = true
			return
		if prompt.bbcode_text == "[wave][center][E] Pick up saw[/center][/wave]":
			prompt.bbcode_text = "[wave][center]It's locked to the wall[/center][/wave]"
			return
		if prompt.bbcode_text == "[wave][center][E] Use key[/center][/wave]":
			prompt.bbcode_text = "[wave][center]Obtained saw[/center][/wave]"
			MetaManager.has_saw = true
			$Room/Room_Model/left_texture.frame = 4
			return
		if prompt.bbcode_text == "[wave][center][E] Leave[/center][/wave]":
			prompt.bbcode_text = ""
			$Control/Transition_AnimationPlayer.play("FadeIn")
			yield(get_tree().create_timer(2.5), "timeout")
			get_tree().change_scene("res://scenes/EndScreen.tscn")
			return
			
func _on_Area_area_entered(area):
	if not MetaManager.got_the_real_key:
		if not tvOn:
			prompt.bbcode_text = "[wave][center][E] Turn on[/center][/wave]"
		else:
			if hasBatteries:
				prompt.bbcode_text = "[wave][center][E] Use batteries[/center][/wave]"
			else:
				prompt.bbcode_text = "[wave][center][E] Turn off[/center][/wave]"

func _on_Area_area_exited(area):
	prompt.bbcode_text = ""

func _on_Door_Area_area_entered(area):
	if not doorOpen:
		prompt.bbcode_text = "[wave][center][E] Open[/center][/wave]"
	else:
		prompt.bbcode_text = "[wave][center][E] Leave[/center][/wave]"

func _on_Door_Area_area_exited(area):
	prompt.bbcode_text = ""

func _on_Batteries_Area_area_entered(area):
	if not hasBatteries:
		prompt.bbcode_text = "[wave][center][E] Pick up[/center][/wave]"

func _on_Batteries_Area_area_exited(area):
	prompt.bbcode_text = ""

func _on_TV_AnimationPlayer2_animation_finished(anim_name):
	if anim_name == "TV_Transition":
		get_tree().change_scene("res://scenes/2d_Main.tscn")

func _on_SawArea_area_entered(area):
	if MetaManager.has_2d_key and not MetaManager.has_saw:
		prompt.bbcode_text = "[wave][center][E] Use key[/center][/wave]"
	else:
		if MetaManager.has_saw:
			prompt.bbcode_text = ""
		else:
			prompt.bbcode_text = "[wave][center][E] Pick up saw[/center][/wave]"

func _on_SawArea_area_exited(area):
	prompt.bbcode_text = ""

func _on_DollArea_area_entered(area):
	if $Room/Doll/Sprite3D.frame == 0:
		prompt.bbcode_text = "[wave][center]A wooden matryoshka[/center][/wave]"
	elif $Room/Doll/Sprite3D.frame == 1:
		prompt.bbcode_text = "[wave][center]Two nesting dolls[/center][/wave]"
	elif $Room/Doll/Sprite3D.frame == 3:
		prompt.bbcode_text = "[wave][center]The complete set[/center][/wave]"

func _on_DollArea_area_exited(area):
	prompt.bbcode_text = ""
