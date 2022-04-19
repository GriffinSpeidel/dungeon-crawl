extends "res://Enemy.gd"

func _initialize(level, id):
	self.id = id
	self.level = level
	self.affinities = [1, 0.5, 2, 1, 1]
	var base_stats = [1, 0.5, 2, 0.67, 2, 0.75]
	self.c_name = "Garbage Ooze"
	for i in range(len(base_stats)):
		stats.append(base_stats[i] * (3 + (level - 1) / 3))
	.set_hp_mp()
	self.skills.append(Global.lunge)
	self.texture = load("res://textures/EnemyHead.png")
