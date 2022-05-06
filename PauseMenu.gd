extends Popup

var party
var item_buttons
var Cancel
var Trash
var CharButtonContainer
var SynthMenu
var SystemMenu
var unequip_buttons
var showing_skills
var skill_windows

func _ready():
	party = get_parent().party
	showing_skills = false
	skill_windows = []
	CharButtonContainer = Control.new()
	CharButtonContainer.rect_position = Vector2(56, 30)
	add_child(CharButtonContainer)

func clear_skill_windows():
	for window in skill_windows:
		window.queue_free()
	skill_windows = []
	showing_skills = false
	$Skill.text = "Show Skills"

func update_portraits():
	for i in range(len($Portraits.get_children())):
		$Portraits.get_children()[i].get_node("NameLabel").text = party[i].c_name + " lvl. " + str(party[i].level)
		$Portraits.get_children()[i].get_node("HealthLabel").text = "HP: " + str(party[i].hp) + "/"  + str(party[i].hp_max)
		$Portraits.get_children()[i].get_node("MagicLabel").text = "MP: " + str(party[i].mp) + "/"  + str(party[i].mp_max)
		$Portraits.get_children()[i].get_node("ExperienceLabel").text = "XP: " + str(party[i].experience) + "/100"

func update_equipment():
	unequip_buttons = [[[],[]],[[],[]],[[],[]]]
	
	for i in range(len($Equipment.get_children())):
		for item in $Equipment.get_children()[i].get_node("UnequipButtons").get_children():
			item.queue_free()
		$Equipment.get_children()[i].get_node("Col1").text = ""
		$Equipment.get_children()[i].get_node("Col1").text += "Str: " + str(party[i].stats[0]) + "\n"
		$Equipment.get_children()[i].get_node("Col1").text += "Dex: " + str(party[i].stats[1]) + "\n"
		$Equipment.get_children()[i].get_node("Col1").text += "Vit: " + str(party[i].stats[2]) + "\n"
		$Equipment.get_children()[i].get_node("Col2").text = ""
		$Equipment.get_children()[i].get_node("Col2").text += "Int: " + str(party[i].stats[3]) + "\n"
		$Equipment.get_children()[i].get_node("Col2").text += "Wis: " + str(party[i].stats[4]) + "\n"
		$Equipment.get_children()[i].get_node("Col2").text += "Luk: " + str(party[i].stats[5]) + "\n"
		$Equipment.get_children()[i].get_node("WeaponLabel").text = "Weapon: " + ("None" if party[i].weapon == null else party[i].weapon.g_name)
		
		if party[i].weapon != null:
			unequip_buttons[i][0] = Button.new()
			unequip_buttons[i][0].text = "X"
			unequip_buttons[i][0].rect_position = Vector2(3, 61)
			unequip_buttons[i][0].mouse_default_cursor_shape = 2
			unequip_buttons[i][0].enabled_focus_mode = 0
			unequip_buttons[i][0].flat = true
			$Equipment.get_children()[i].get_node("UnequipButtons").add_child(unequip_buttons[i][0])
			unequip_buttons[i][0].connect("pressed", self, "unequip", [party[i].weapon, i])
		$Equipment.get_children()[i].get_node("SkillLabel").text = "Learning skill: " + ("None " if (party[i].weapon == null or len(party[i].weapon.skills) == 0 or party[i].skills.has(party[i].weapon.skills[0])) else (party[i].weapon.skills[0].s_name + "  " + str(party[i].weapon.ap) + "/" + str(party[i].weapon.thresholds[0]) + "AP"))
		$Equipment.get_children()[i].get_node("ArmorLabel").text = "Armor: " + ("None" if party[i].armor == null else party[i].armor.g_name)
		
		if party[i].armor != null:
			unequip_buttons[i][0] = Button.new()
			unequip_buttons[i][0].text = "X"
			unequip_buttons[i][0].rect_position = Vector2(3, 93)
			unequip_buttons[i][0].mouse_default_cursor_shape = 2
			unequip_buttons[i][0].enabled_focus_mode = 0
			unequip_buttons[i][0].flat = true
			$Equipment.get_children()[i].get_node("UnequipButtons").add_child(unequip_buttons[i][0])
			unequip_buttons[i][0].connect("pressed", self, "unequip", [party[i].armor, i])
		
		var temp = ""
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
			temp += "Null:"
			for e in nullify:
				temp += " " + e
			temp += "; " if (len(resist) > 0 or len(weak) > 0) else ""
		if len(resist) > 0:
			temp += "Res:"
			for e in resist:
				temp += " " + e
			temp += "; " if len(weak) > 0 else ""
		if len(weak) > 0:
			temp += "Weak:"
			for e in weak:
				temp += " " + e
		$Equipment.get_children()[i].get_node("AffinityLabel").text = "No elemental affinities" if temp == "" else temp

func update_inventory():
	item_buttons = [[],[],[]]
	for i in range(3):
		for child in $Inventory/ReferenceRect.get_children()[i].get_children():
			child.queue_free()
	var inventory = get_parent().inventory
	var cols = [[],[],[]]
	for item in inventory:
		for col in cols:
			if len(col) < 8:
				col.append(item)
				break
	for i in range(3):
		for j in range(len(cols[i])):
			item_buttons[i].append(Button.new())
			item_buttons[i][j].text = cols[i][j].g_name
			item_buttons[i][j].text += " " + str(cols[i][j].freshness) if cols[i][j] is Consumeable else ""
			item_buttons[i][j].rect_position = Vector2(0, 21 * j)
			item_buttons[i][j].rect_size = Vector2(26, 16)
			item_buttons[i][j].mouse_default_cursor_shape = 2
			item_buttons[i][j].enabled_focus_mode = 0
			$Inventory/ReferenceRect.get_children()[i].add_child(item_buttons[i][j])
			item_buttons[i][j].connect("pressed", self, "_on_ItemButton_pressed", [cols[i][j], i, j])

func disable_buttons():
	for col in item_buttons:
		for button in col:
			button.disabled = true
			button.mouse_default_cursor_shape = 0
	for k in range(3):
		for button in $Equipment.get_child(k).get_node("UnequipButtons").get_children():
			button.disabled = true
			button.mouse_default_cursor_shape = 0
	clear_skill_windows()
	$System.disabled = true
	$System.mouse_default_cursor_shape = 0
	$Sort.disabled = true
	$Sort.mouse_default_cursor_shape = 0
	$Skill.disabled = true
	$Skill.mouse_default_cursor_shape = 0
	$Synth.disabled = true
	$Synth.mouse_default_cursor_shape = 0

func _on_ItemButton_pressed(item, i, j):
	disable_buttons()
	
	Cancel = Button.new()
	Cancel.name = "Cancel"
	Cancel.rect_position = Vector2(item_buttons[i][j].rect_size[0] + 16, 21 * j)
	Cancel.rect_size = Vector2(26, 16)
	Cancel.mouse_default_cursor_shape = 2
	Cancel.enabled_focus_mode = 0
	Cancel.text = "Cancel"
	$Inventory/ReferenceRect.get_children()[i].add_child(Cancel)
	Cancel.connect("pressed", self, "enable_item_buttons")
	
	Trash = Button.new()
	Trash.rect_position = Vector2(Cancel.rect_position[0] + 62, 21 * j)
	Trash.rect_size = Vector2(26, 16)
	Trash.mouse_default_cursor_shape = 2
	Trash.enabled_focus_mode = 0
	Trash.text = "Trash"
	$Inventory/ReferenceRect.get_children()[i].add_child(Trash)
	Trash.connect("pressed", self, "trash_item", [item])
	
	var char_buttons = []
	for k in range(3):
		char_buttons.append(Button.new())
		char_buttons[k].icon = party[k].texture
		char_buttons[k].rect_position = Vector2(300 * k + 1, 0)
		char_buttons[k].mouse_default_cursor_shape = 2
		char_buttons[k].enabled_focus_mode = 0
		if item.type != 2 or item.variety != 2:
			CharButtonContainer.add_child(char_buttons[k])
		char_buttons[k].connect("pressed", self, "_on_CharButton_pressed", [item, k])
		char_buttons[k].connect("pressed", self, "enable_item_buttons")
	
	if item is Consumeable:
		$Details/Label.text = item.description
	else:
		var stat_string = ""
		var add_comma = false
		for i in len(item.stats):
			if item.stats[i] != 0:
				stat_string += ", " if add_comma else ""
				stat_string += Global.stat_names[i] + " "
				stat_string += "+" if item.stats[i] > 0 else ""
				stat_string += str(item.stats[i])
				add_comma = true
		if item is Weapon:
			for k in range(3):
				$Equipment.get_children()[k].get_node("Col1").text = ""
				var new_str = party[k].stats[0] + item.stats[0] - (0 if party[k].weapon == null else party[k].weapon.stats[0])
				$Equipment.get_children()[k].get_node("Col1").text += "Str: " + str(new_str) + " (" + ("+" if (new_str - party[k].stats[0]) >= 0 else "") + str(new_str - party[k].stats[0]) + ")" + "\n"
				var new_dex = party[k].stats[1] + item.stats[1] - (0 if party[k].weapon == null else party[k].weapon.stats[1])
				$Equipment.get_children()[k].get_node("Col1").text += "Dex: " + str(new_dex) + " (" + ("+" if (new_dex - party[k].stats[1]) >= 0 else "") + str(new_dex - party[k].stats[1]) + ")" + "\n"
				var new_vit = party[k].stats[2] + item.stats[2] - (0 if party[k].weapon == null else party[k].weapon.stats[2])
				$Equipment.get_children()[k].get_node("Col1").text += "Vit: " + str(new_vit) + " (" + ("+" if (new_vit - party[k].stats[2]) >= 0 else "") + str(new_vit - party[k].stats[2]) + ")" +"\n"
				$Equipment.get_children()[k].get_node("Col2").text = ""
				var new_int = party[k].stats[3] + item.stats[3] - (0 if party[k].weapon == null else party[k].weapon.stats[3])
				$Equipment.get_children()[k].get_node("Col2").text += "Int: " + str(new_int) + " (" + ("+" if (new_int - party[k].stats[3]) >= 0 else "") + str(new_int - party[k].stats[3]) + ")" +"\n"
				var new_wis = party[k].stats[4] + item.stats[4] - (0 if party[k].weapon == null else party[k].weapon.stats[4])
				$Equipment.get_children()[k].get_node("Col2").text += "Wis: " + str(new_wis) + " (" + ("+" if (new_wis - party[k].stats[4]) >= 0 else "") + str(new_wis - party[k].stats[4]) + ")" +"\n"
				var new_luk = party[k].stats[5] + item.stats[5] - (0 if party[k].weapon == null else party[k].weapon.stats[5])
				$Equipment.get_children()[k].get_node("Col2").text += "Luk: " + str(new_luk) + " (" + ("+" if (new_luk - party[k].stats[5]) >= 0 else "") + str(new_luk - party[k].stats[5]) + ")" +"\n"
			
			if len(item.skills) > 0:
				stat_string += "; " + item.skills[0].s_name
		elif item is Armor:
			for k in range(3):
				$Equipment.get_children()[k].get_node("Col1").text = ""
				var new_str = party[k].stats[0] + item.stats[0] - (0 if party[k].armor == null else party[k].armor.stats[0])
				$Equipment.get_children()[k].get_node("Col1").text += "Str: " + str(new_str) + " (" + ("+" if (new_str - party[k].stats[0]) >= 0 else "") + str(new_str - party[k].stats[0]) + ")" + "\n"
				var new_dex = party[k].stats[1] + item.stats[1] - (0 if party[k].armor == null else party[k].armor.stats[1])
				$Equipment.get_children()[k].get_node("Col1").text += "Dex: " + str(new_dex) + " (" + ("+" if (new_dex - party[k].stats[1]) >= 0 else "") + str(new_dex - party[k].stats[1]) + ")" + "\n"
				var new_vit = party[k].stats[2] + item.stats[2] - (0 if party[k].armor == null else party[k].armor.stats[2])
				$Equipment.get_children()[k].get_node("Col1").text += "Vit: " + str(new_vit) + " (" + ("+" if (new_vit - party[k].stats[2]) >= 0 else "") + str(new_vit - party[k].stats[2]) + ")" +"\n"
				$Equipment.get_children()[k].get_node("Col2").text = ""
				var new_int = party[k].stats[3] + item.stats[3] - (0 if party[k].armor == null else party[k].armor.stats[3])
				$Equipment.get_children()[k].get_node("Col2").text += "Int: " + str(new_int) + " (" + ("+" if (new_int - party[k].stats[3]) >= 0 else "") + str(new_int - party[k].stats[3]) + ")" +"\n"
				var new_wis = party[k].stats[4] + item.stats[4] - (0 if party[k].armor == null else party[k].armor.stats[4])
				$Equipment.get_children()[k].get_node("Col2").text += "Wis: " + str(new_wis) + " (" + ("+" if (new_wis - party[k].stats[4]) >= 0 else "") + str(new_wis - party[k].stats[4]) + ")" +"\n"
				var new_luk = party[k].stats[5] + item.stats[5] - (0 if party[k].armor == null else party[k].armor.stats[5])
				$Equipment.get_children()[k].get_node("Col2").text += "Luk: " + str(new_luk) + " (" + ("+" if (new_luk - party[k].stats[5]) >= 0 else "") + str(new_luk - party[k].stats[5]) + ")" +"\n"
			
			var aff_string = "; "
			var weak = []
			var nullify = []
			var resist = []
			for j in range(len(item.affinities)):
				if item.affinities[j] == 0:
					nullify.append(Global.element_names[j])
				elif item.affinities[j] > 1:
					weak.append(Global.element_names[j])
				elif item.affinities[j] < 1:
					resist.append(Global.element_names[j])
			if len(nullify) > 0:
				aff_string += "Null:"
				for e in nullify:
					aff_string += " " + e
				aff_string += "; " if (len(resist) > 0 or len(weak) > 0) else ""
			if len(resist) > 0:
				aff_string += "Res:"
				for e in resist:
					aff_string += " " + e
				aff_string += "; " if len(weak) > 0 else ""
			if len(weak) > 0:
				aff_string += "Weak:"
				for e in weak:
					aff_string += " " + e
			stat_string += aff_string if aff_string != "; " else ""
		$Details/Label.text = stat_string
	

func trash_item(item):
	get_parent().inventory.erase(item)
	update_inventory()
	enable_item_buttons()

func _on_CharButton_pressed(item, i):
	if item is Equipment:
		get_parent().party[i].equip(item)
		update_equipment()
	elif item is Consumeable:
		item.use(get_parent().party[i])
	var inventory = get_parent().inventory
	for j in range(len(inventory)):
		if item == inventory[j]:
			inventory.remove(j)
			break
	update_inventory()
	update_portraits()
	clear_char_buttons()

func clear_char_buttons():
	for child in CharButtonContainer.get_children():
		child.queue_free()

func enable_item_buttons():
	update_inventory()
	update_equipment()
	clear_char_buttons()
	$Details/Label.text = ""
	for col in item_buttons:
		for button in col:
			button.disabled = false
			button.mouse_default_cursor_shape = 2
	for k in range(3):
		for button in $Equipment.get_child(k).get_node("UnequipButtons").get_children():
			button.disabled = false
			button.mouse_default_cursor_shape = 2
	enable_bottom_buttons()

func enable_bottom_buttons():
	$System.disabled = false
	$System.mouse_default_cursor_shape = 2
	$Sort.disabled = false
	$Sort.mouse_default_cursor_shape = 2
	$Synth.disabled = false
	$Synth.mouse_default_cursor_shape = 2
	$Skill.disabled = false
	$Skill.mouse_default_cursor_shape = 2

func unequip(item, character):
	if item is Weapon:
		party[character].unequip_weapon()
	elif item is Armor:
		party[character].unequip_armor()
	update_portraits()
	update_equipment()
	update_inventory()

func _on_Sort_pressed():
	get_parent().inventory.sort_custom(CustomSorter, "sort_items")
	update_inventory()

class CustomSorter:
	static func sort_items(a, b):
		if a.type != b.type:
			return a.type < b.type
		if a.type == 2:
			if a.variety != b.variety:
				return a.variety < b.variety
			return a.freshness < b.freshness
		return a.g_name < b.g_name

func _on_Skill_pressed():
	if showing_skills:
		clear_skill_windows()
	else:
		for i in range(3):
			var SkillWindow = ColorRect.new()
			SkillWindow.rect_position = Vector2(1, 16)
			SkillWindow.rect_size = Vector2(265, 115)
			SkillWindow.color = Color(29.0/255, 29.0/255, 29.0/255)
			skill_windows.append(SkillWindow)
			$Equipment.get_child(i).add_child(SkillWindow)
			
			var SkillScroll = ScrollContainer.new()
			SkillScroll.rect_position = Vector2(25, 0)
			SkillScroll.rect_size = Vector2(260, 106)
			SkillWindow.add_child(SkillScroll)
			
			var SkillControl = Control.new()
			#SkillControl.rect_size = Vector2(248, 112)
			SkillScroll.add_child(SkillControl)
			
			var j = 0
			var asdf = party[i].skills
			for skill in party[i].skills:
				var SkillLabel = Label.new()
				SkillLabel.text = skill.s_name + " "
				SkillLabel.text += (str(skill.m_cost) + "MP") if skill.m_cost > 0 else (str(int((party[i].hp_max - (4 * Global.damage_scale * (party[i].stats[2] - 3))) * skill.h_cost)) + "HP")
				SkillLabel.rect_position = Vector2(0, 17 * j)
				j += 1
				SkillControl.add_child(SkillLabel)
			SkillControl.rect_min_size = Vector2(248, 17 * j)

		showing_skills = true
		$Skill.text = "Hide Skills"

func _on_Synth_pressed():
	var synth_menu_res = load("res://SynthMenu.tscn")
	SynthMenu = synth_menu_res.instance()
	SynthMenu.name = "SynthMenu"
	SynthMenu._initialize(get_parent().materials, get_parent().inventory)
	add_child(SynthMenu)

func clear_synthesis():
	update_inventory()
	if has_node("SynthMenu"):
		SynthMenu.queue_free()

func clear_system():
	$SystemMenu.visible = false

func _on_System_pressed():
	$SystemMenu.visible = true
	disable_buttons()

func _on_SystemMenu_close_sys():
	$SystemMenu.visible = false
	enable_item_buttons()

func _on_SystemMenu_load_game():
	get_parent().load_game()

func _on_SystemMenu_save_game():
	get_parent().save_game()
