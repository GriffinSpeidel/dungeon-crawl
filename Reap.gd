extends Control
var character
var enemy
var hp
var mp
var xp
signal reap_health
signal reap_magic
signal reap_xp

func _initialize(c, e):
	character = c
	enemy = e
	hp = int(e.hp_max / 4)
	mp = int((2 + e.level) * (1 + ((e.base_stats[4] - 1) / 2)))
	xp = max(int((20 + (e.level - c.level) * 10) / 4), 1)
	$Label.text = "Choose reap boost for " + c.c_name + ":"
	$Health.text = "Restore " + str(hp) + "HP"
	$Magic.text = "Restore " + str(mp) + "MP"
	$Experience.text = "Bonus " + str(xp) + "XP"

func _on_Health_pressed():
	emit_signal("reap_health", character, enemy, hp)

func _on_Magic_pressed():
	emit_signal("reap_magic", character, enemy, mp)

func _on_Experience_pressed():
	emit_signal("reap_xp", character, enemy, xp)
