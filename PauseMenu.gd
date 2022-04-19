extends Popup

var party
signal unpause

func _ready():
	party = get_parent().party

func _on_Unpause_pressed():
	emit_signal("unpause")

func update_portraits():
	for i in range(len($Portraits.get_children())):
		$Portraits.get_children()[i].get_node("NameLabel").text = party[i].c_name + " lvl. " + str(party[i].level)
		$Portraits.get_children()[i].get_node("HealthLabel").text = "HP: " + str(party[i].hp) + "/"  + str(party[i].hp_max)
		$Portraits.get_children()[i].get_node("MagicLabel").text = "MP: " + str(party[i].mp) + "/"  + str(party[i].mp_max)
		$Portraits.get_children()[i].get_node("ExperienceLabel").text = "XP: " + str(party[i].experience) + "/100"

func update_equipment():
	for i in range(len($Equipment.get_children())):
		$Equipment.get_children()[i].get_node("Col1").text = ""
		$Equipment.get_children()[i].get_node("Col1").text += "Str: " + str(party[i].stats[0]) + "\n"
		$Equipment.get_children()[i].get_node("Col1").text += "Dex: " + str(party[i].stats[1]) + "\n"
		$Equipment.get_children()[i].get_node("Col1").text += "Vit: " + str(party[i].stats[2]) + "\n"
		$Equipment.get_children()[i].get_node("Col2").text = ""
		$Equipment.get_children()[i].get_node("Col2").text += "Int: " + str(party[i].stats[3]) + "\n"
		$Equipment.get_children()[i].get_node("Col2").text += "Wis: " + str(party[i].stats[4]) + "\n"
		$Equipment.get_children()[i].get_node("Col2").text += "Luk: " + str(party[i].stats[5]) + "\n"
		$Equipment.get_children()[i].get_node("WeaponLabel").text = "Weapon: " + ("None" if party[i].weapon == null else party[i].weapon.g_name)
		$Equipment.get_children()[i].get_node("SkillLabel").text = "Learning skill: " + ("None " if (party[i].weapon == null or len(party[i].weapon.skills) == 0) else (party[i].weapon.skills[0].s_name + "  " + str(party[i].weapon.ap) + "/" + str(party[i].weapon.thresholds[0]) + "AP"))
		$Equipment.get_children()[i].get_node("ArmorLabel").text = "Armor: " + ("None" if party[i].armor == null else party[i].armor.g_name)
		$Equipment.get_children()[i].get_node("AffinityLabel").text = ""
		var weak = []
		var nullify = []
		var resist = []
		for j in range(len(party[i].affinities)):
			if party[i].affinities[j] == 0:
				nullify.append(Global.element_names[j])
			elif party[i].affinities[j] > 1:
				weak.append(Global.element_names[j])
			elif party[i].affinities[j] < 1:
				resist.append(Global.element_names[j])
		if len(nullify) > 0:
			$Equipment.get_children()[i].get_node("AffinityLabel").text += "Null:"
			for e in nullify:
				$Equipment.get_children()[i].get_node("AffinityLabel").text += " " + e
			$Equipment.get_children()[i].get_node("AffinityLabel").text += "; " if (len(resist) > 0 or len(weak) > 0) else ""
		if len(resist) > 0:
			$Equipment.get_children()[i].get_node("AffinityLabel").text += "Res:"
			for e in resist:
				$Equipment.get_children()[i].get_node("AffinityLabel").text += " " + e
			$Equipment.get_children()[i].get_node("AffinityLabel").text += "; " if len(weak) > 0 else ""
		if len(weak) > 0:
			$Equipment.get_children()[i].get_node("AffinityLabel").text += "Weak:"
			for e in weak:
				$Equipment.get_children()[i].get_node("AffinityLabel").text += " " + e
