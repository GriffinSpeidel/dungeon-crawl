extends Control

var showing_stats

func _ready():
	var stat_string = "XP Gained: " + str(Global.xp_gained)
	stat_string += "\nAP Gained: " + str(Global.ap_gained)
	stat_string += "\nSteps taken: " + str(Global.steps_taken)
	stat_string += "\nEnemies defeated: " + str(Global.enemies_defeated)
	stat_string += "\nItems Synthesized: " + str(Global.items_synthed)
	stat_string += "\nNumber of Reaps: " + str(Global.num_reaps)
	stat_string += "\nNumber of Party Wipes: " + str(Global.num_wipes)
	$ReferenceRect/ColorRect/Label.text = stat_string
	
	showing_stats = false
	if Global.true_ending:
		$ReferenceRect/Label.text = "As the last of the Gremlin Sigma's energies facde,\nyou are left in the ruins of the dungeon that you fought\nso hard to infiltrate. It does not return to its original state,\nhowever; the divine power of Excalibur has granted you\nthe power of the lord of this realm. Rule it as you see\nfit, and be certain to never let it fall into capitalism's\nvile clutches!"
		if Global.hard_mode:
			$ReferenceRect/Label.text += "\n\nCongratulations on completing the true ending of the\ngame on the highest difficulty setting! Clearly, you are in\nseverely dire need of sunlight."
	else:
		if Global.hard_mode:
			$ReferenceRect/Label.text += "Hold 'g' while starting to enter god mode, or 'm' to enter funny mode."
		else:
			$ReferenceRect/Label.text += "Up for a challenge? Hold 'h' while starting the game >:)"


func _on_CloseGame_pressed():
	get_tree().quit()


func _on_ShowStats_pressed():
	$ReferenceRect/ColorRect.visible = not $ReferenceRect/ColorRect.visible
	$ReferenceRect/ShowStats.text = "Hide Stats" if $ReferenceRect/ColorRect.visible else "Show Stats"
	
