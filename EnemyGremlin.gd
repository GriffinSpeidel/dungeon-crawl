extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [0.5, 2, 2, 1, 1]
	base_stats = [1.1, 1.1, 0.9, 1, 0.9, 1]
	self.c_name = "Gremlin Alpa"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 6))
	.set_hp_mp()
	if self.level <= 7:
		skills.append(Global.lunge)
	if self.level >= 5:
		skills.append(Global.eviscerate)
	self.texture = preload("res://textures/gremlin.png")
	self.mat_drops = [4, 5]
