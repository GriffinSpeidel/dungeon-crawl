extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 1, 1, 1, 1]
	base_stats = [1, 1, 1, 1, 1, 1]
	self.c_name = "Stupid Gremlin"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 6))
	.set_hp_mp()
	if self.level <= 7:
		skills.append(Global.feuer)
		skills.append(Global.eis)
		skills.append(Global.blitz)
		skills.append(Global.sturm)
	if self.level >= 5:
		skills.append(Global.feuer_ex)
		skills.append(Global.eis_ex)
		skills.append(Global.blitz_ex)
		skills.append(Global.sturm_ex)
	self.texture = preload("res://textures/gremlin.png")
	self.mat_drops = [4, 5]
