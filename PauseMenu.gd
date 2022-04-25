extends Popup

var party
var item_buttons
var Cancel
var Trash
var CharButtonContainer
var SynthMenu
var unequip_buttons
var showing_skills
var skill_windows
signal unpause

func _ready():
	party = get_parent().party
	showing_skills = false
	skill_windows = []

func _on_Unpause_pressed():
	clear_skill_windows()
	emit_signal("unpause")

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
	var useable = []
	for item in inventory:
		if not item is CraftMaterial:
			useable.append(item)
	var cols = [[],[],[]]
	for item in useable:
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

func _on_ItemButton_pressed(item, i, j):
	for col in item_buttons:
		for button in col:
			button.disabled = true
	for k in range(3):
		for button in $Equipment.get_child(k).get_node("UnequipButtons").get_children():
			button.disabled = true
	clear_skill_windows()
	$Unpause.disabled = true
	$Sort.disabled = true
	$Skill.disabled = true
	$Synth.disabled = true
	
	Cancel = Button.new()
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
	CharButtonContainer = Control.new()
	CharButtonContainer.rect_position = Vector2(56, 30)
	add_child(CharButtonContainer)
	for k in range(3):
		char_buttons.append(Button.new())
		char_buttons[k].icon = load("res://textures/Face1.png")
		char_buttons[k].rect_position = Vector2(300 * k, 0)
		char_buttons[k].mouse_default_cursor_shape = 2
		char_buttons[k].enabled_focus_mode = 0
		CharButtonContainer.add_child(char_buttons[k])
		char_buttons[k].connect("pressed", self, "_on_CharButton_pressed", [item, k])
		char_buttons[k].connect("pressed", self, "enable_item_buttons")

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
	if typeof(CharButtonContainer) != TYPE_NIL:
		CharButtonContainer.queue_free()

func enable_item_buttons():
	if typeof(Cancel) != TYPE_NIL:
		Cancel.queue_free()
	for col in item_buttons:
		for button in col:
			button.disabled = false
	if typeof(CharButtonContainer) != TYPE_NIL:
		CharButtonContainer.queue_free()
	for k in range(3):
		for button in $Equipment.get_child(k).get_node("UnequipButtons").get_children():
			button.disabled = false
	$Unpause.disabled = false
	$Sort.disabled = false
	$Synth.disabled = false
	$Skill.disabled = false

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
			SkillScroll.rect_size = Vector2(260, 112)
			SkillWindow.add_child(SkillScroll)
			
			var SkillControl = Control.new()
			SkillControl.rect_size = Vector2(248, 112)
			SkillControl.rect_min_size = Vector2(248, 112)
			SkillScroll.add_child(SkillControl)
			
			var j = 0
			for skill in party[i].skills:
				var SkillLabel = Label.new()
				SkillLabel.text = skill.s_name + " "
				SkillLabel.text += (str(skill.m_cost) + "MP") if skill.m_cost > 0 else (str(int(skill.h_cost * party[i].hp_max)) + "HP")
				SkillLabel.rect_position = Vector2(0, 17 * j)
				j += 1
				SkillControl.add_child(SkillLabel)
		
		showing_skills = true
		$Skill.text = "Hide Skills"

func _on_Synth_pressed():
	var synth_menu_res = load("res://SynthMenu.tscn")
	SynthMenu = synth_menu_res.instance()
	SynthMenu._initialize(get_parent().materials, get_parent().inventory)
	add_child(SynthMenu)

func clear_synthesis():
	update_inventory()
	if SynthMenu != null:
		SynthMenu.queue_free()
