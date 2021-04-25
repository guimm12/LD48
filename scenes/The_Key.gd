extends Node2D

func _process(delta):
	self.transform = get_parent().get_node("Player_Plataformer").transform
	self.position.y -= 20
