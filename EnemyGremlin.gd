extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 1, 1, 1, 1]
	base_stats = [1.3, 1.3, 1, 1.3, 1, 2]
	self.c_name = "Gremlin King"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 6))
	.set_hp_mp()
	skills.append(Global.eviscerate)
	skills.append(Global.feuer_ex)
	skills.append(Global.eis_ex)
	skills.append(Global.blitz_ex)
	skills.append(Global.sturm_ex)
	self.texture = load("res://textures/EnemyHead.png")
	self.mat_drops = [4, 5]
