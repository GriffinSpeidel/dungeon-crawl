extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 0.5, 0.5, 2, 2]
	base_stats = [0.9, 1, 0.9, 1.1, 1.1, 1]
	self.c_name = "Gremlin Beta"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 6))
	.set_hp_mp()
	if self.level <= 7:
		skills.append(Global.feuer)
		skills.append(Global.eis)
		skills.append(Global.sturm)
		skills.append(Global.blitz)
	if self.level >= 5:
		skills.append(Global.feuer_ex)
		skills.append(Global.eis_ex)
		skills.append(Global.sturm_ex)
		skills.append(Global.blitz_ex)
	self.texture = preload("res://textures/gremlin.png")
	self.mat_drops = [4, 5]
