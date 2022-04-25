extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 1, 1, 0.5, 2]
	base_stats = [1.3, 1, 0.77, 1, 1, 1]
	self.c_name = "Floating Head"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 3))
	.set_hp_mp()
	self.skills.append(Global.lunge)
	self.skills.append(Global.blitz)
	self.texture = load("res://textures/EnemyHead.png")
	self.mat_drops = [1, 5, 8]
