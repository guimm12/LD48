extends Sprite


var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	while true:
		yield(get_tree().create_timer(rng.randf_range(.1, .6)), "timeout")
		visible = false
		yield(get_tree().create_timer(rng.randf_range(.1, .6)), "timeout")
		visible = true
