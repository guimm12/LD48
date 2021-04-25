extends Node2D

var picked_up = false

func _ready():
	if not MetaManager.has_2d_key:
		picked_up = false
		$Sprite.frame = 1
	if MetaManager.has_saw or MetaManager.has_2d_key:
		picked_up = true
	if MetaManager.has_saw:
		$Sprite.frame = 0

func _process(delta):
	if MetaManager.used_saw:
		self.visible = false
		return
	
	if picked_up == true:
		self.transform = get_parent().get_node("Player_Plataformer").transform
		self.position.y -= 20

func has_been_picked_up():
	picked_up = true
	MetaManager.has_2d_key = true
	get_parent().get_node("Spawn").transform = self.transform
