extends Node

var has_2d_key = false
var has_saw = false
var has_batteries = false
var entered_tv_once = false
var used_saw = false
var got_the_real_key = false

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
