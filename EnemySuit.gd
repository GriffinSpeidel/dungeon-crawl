extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 1, 0.5, 2, 1]
	base_stats = [1, 0.9, 1.2, 1.1, 0.77, 1]
	self.c_name = "Animated Suit"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 6))
	.set_hp_mp()
	if self.level <= 7:
		self.skills.append(Global.eis)
		self.skills.append(Global.feuer)
	if self.level >= 5:
		self.skills.append(Global.eis_ex)
		self.skills.append(Global.feuer_ex)
	self.texture = preload("res://textures/suit.png")
	self.mat_drops = [0, 5, 7]
