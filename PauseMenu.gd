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
