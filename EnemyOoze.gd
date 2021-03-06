extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 0.5, 2, 1, 1]
	base_stats = [1.3, 0.5, 1.8, 1, 1.8, 0.75]
	self.c_name = "Garbage Ooze"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 6))
	.set_hp_mp()
	if self.level <= 7:
		self.skills.append(Global.lunge)
	if self.level >= 5:
		self.skills.append(Global.eviscerate)
	self.texture = preload("res://textures/ooze.png")
	self.mat_drops = [2, 4, 6]
