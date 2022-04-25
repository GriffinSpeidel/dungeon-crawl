extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 1, 0.5, 2, 1]
	base_stats = [1.1, 0.9, 1.3, 1, 0.77, 1]
	self.c_name = "Animated Suit"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 3))
	.set_hp_mp()
	self.skills.append(Global.eis)
	self.skills.append(Global.feuer)
	self.texture = load("res://textures/EnemyHead.png")
	self.mat_drops = [0, 5, 7]
