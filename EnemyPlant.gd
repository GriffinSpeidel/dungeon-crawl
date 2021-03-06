extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 2, 1, 1, 0.5]
	base_stats = [0.77, 0.8, 1, 1.4, 2, 1]
	self.c_name = "Crawling Plant"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 6))
	.set_hp_mp()
	if self.level <= 7:
		self.skills.append(Global.sturm)
	if self.level >= 5:
		self.skills.append(Global.sturm_ex)
	self.texture = preload("res://textures/plant.png")
	self.mat_drops = [3, 4, 9]
