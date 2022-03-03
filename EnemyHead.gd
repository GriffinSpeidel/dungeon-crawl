extends "res://Enemy.gd"

func _initialize(level):
	self.level = level
	self.affinities = [1, 1, 1, 1, 1]
	var base_stats = [1, 1, 1, 1, 1, 1]
	self.type = "Floating Head"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 3))
	.set_hp()
	self.texture = load("res://textures/EnemyHead.png")
