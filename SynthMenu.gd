extends Control

var materials
var inventory

var weapon_recipes = [
	[[Weapon, [2,0,0,0,0,0], "Baseball Bat", [Global.lunge], [20]],
	[[4, 2], [5, 2], [10, 2]]], # 2 food scrap, 2 debris, 2 raw materials
	[[Weapon, [1,1,0,0,0,0], "Pocket Knife", [Global.feuer], [20]],
	[[1, 2], [10, 2]]], # 2 teeth, 2 raw materials
	[[Weapon, [1,0,0,1,0,0], "Portable Icebox", [Global.eis], [20]],
	[[3, 2], [10, 2]]], # 2 cool herb, 2 raw materials
	[[Weapon, [0,0,0,1,1,0], "Power Strip", [Global.blitz], [20]],
	[[2, 2], [10, 2]]], # 2 sludge, 2 raw materials
	[[Weapon, [1,0,1,0,0,0], "Vacuum Cleaner", [Global.sturm], [20]],
	[[0, 2], [10, 2]]], # 2 floating fabric, 2 raw materials
	[[Weapon, [3,-1,1,-1,0,0], "Spiked Club", [Global.eviscerate], [100]],
	[[4, 6], [5, 6], [10, 8]]], # 2 food scrap, 2 debris, 2 raw materials
	[[Weapon, [2,2,0,0,0,0], "Ceramic Sword", [Global.feuer_ex], [100]],
	[[1, 8], [10, 8]]], # 2 teeth, 2 raw materials
	[[Weapon, [1,0,1,1,1,0], "Freezer", [Global.eis_ex], [100]],
	[[3, 8], [10, 8]]], # 2 cool herb, 2 raw materials
	[[Weapon, [-2,-1,0,3,2,0], "Tesla Coil", [Global.blitz_ex], [100]],
	[[2, 8], [10, 8]]], # 2 sludge, 2 raw materials
	[[Weapon, [2,0,2,0,0,0], "Leaf Blower", [Global.sturm_ex], [100]],
	[[0, 8], [10, 8]]] # 2 floating fabric, 2 raw materials
]

var armor_recipes = [
	[[Armor, [0,0,1,0,0,0], "Fancy Suit", [1,1,1,1,1]],
	[[0, 2], [10, 1]]], # 2 floating fabric, 1 raw material
	[[Armor, [0,0,2,0,0,0], "Bulletproof Vest", [0.5,1,1,1,1]],
	[[4, 4], [5, 4], [10, 6]]], # 4 food scraps, 4 debris, 6 raw materials
	[[Armor, [0,0,0,0,1,0], "Asbestos Cloak", [1,0.5,2,1,1]],
	[[6, 2], [10, 2]]], # 2 liquid asbestos, 2 raw materials
	[[Armor, [0,0,1,0,0,0], "Winter Coat", [1,2,0.5,1,1]],
	[[7, 2], [10, 2]]], # 2 itchy wool, 2 raw materials
	[[Armor, [0,0,1,0,0,0], "Rubber Suit", [1,1,1,0.5,2]],
	[[8, 2], [10, 2]]], # 2 stretchy skin, 2 raw materials
	[[Armor, [0,0,0,0,1,0], "Wind Jacket", [1,1,1,2,0.5]],
	[[9, 2], [10, 2]]] # 2 fig leaves, 2 raw materials
]

func _initialize(materials, inventory):
	self.materials = materials
	self.inventory = inventory
	check_weapons()
	check_armor()

func check_weapons():
	var selection_box_res = load("res://SynthSelection.tscn")
	var num_craftable = 0
	for recipe in weapon_recipes:
		var show_item = false
		for mat in recipe[1]:
			if mat[0] != 10 and materials[mat[0]] > 0: 
# if the player material inventory slot for the correct material id is less than the requirement for the item
				show_item = true
				break
		if show_item:
			var SynthBox = selection_box_res.instance()
			SynthBox.get_node("ReferenceRect/Name").text = recipe[0][2]
			var mat_list_string = ""
			for mat in recipe[1]:
				mat_list_string += Global.material_names[mat[0]] + " x" + str(mat[1]) + "\n"
			SynthBox.get_node("ReferenceRect/Materials").text = mat_list_string
			
			SynthBox.rect_position = Vector2(1, 62 * num_craftable + 1)
			$SelectionWindow/Col1/Control.add_child(SynthBox)
			
			SynthBox.get_node("ReferenceRect/Select").connect("pressed", self, "show_detail", [recipe[0], recipe[1]])
			
			num_craftable += 1
	
	var show_excalibur = true
	for mat in materials.slice(0, 5):
		if mat < 12:
			show_excalibur = false
			break
	if show_excalibur:
		var SynthBox = selection_box_res.instance()
		SynthBox.get_node("ReferenceRect/Name").text = "Excalibur"
		var mat_list_string = ""
		for mat in [12, 12, 12, 12, 12, 12]:
			mat_list_string += Global.material_names[mat[0]] + " x" + str(mat[1]) + "\n"
		SynthBox.get_node("ReferenceRect/Materials").text = mat_list_string
		
		SynthBox.rect_position = Vector2(1, 62 * num_craftable + 1)
		$SelectionWindow/Col1/Control.add_child(SynthBox)
		
		SynthBox.get_node("ReferenceRect/Select").connect("pressed", self, "show_detail", [recipe[0], recipe[1]])
		
		num_craftable += 1
	
	$SelectionWindow/Col1/Control.rect_min_size = Vector2(404, 62 * num_craftable + 4)
	if num_craftable == 0:
		var NoCraftLabel = Label.new()
		NoCraftLabel.text = "No weapons available for synthesis."
		$SelectionWindow/Col1/Control.add_child(NoCraftLabel)

func check_armor():
	var selection_box_res = load("res://SynthSelection.tscn")
	var num_craftable = 0
	for recipe in armor_recipes:
		var show_item = false
		for mat in recipe[1]:
			if mat[0] != 10 and materials[mat[0]] > 0: 
# if the player material inventory slot for the correct material id is less than the requirement for the item
				show_item = true
				break
		if show_item:
			var SynthBox = selection_box_res.instance()
			SynthBox.get_node("ReferenceRect/Name").text = recipe[0][2]
			var mat_list_string = ""
			for mat in recipe[1]:
				mat_list_string += Global.material_names[mat[0]] + " x" + str(mat[1]) + "\n"
			SynthBox.get_node("ReferenceRect/Materials").text = mat_list_string
			
			SynthBox.rect_position = Vector2(1, 62 * num_craftable + 1)
			$SelectionWindow/Col2/Control.add_child(SynthBox)
			
			SynthBox.get_node("ReferenceRect/Select").connect("pressed", self, "show_detail", [recipe[0], recipe[1]])
			
			num_craftable += 1
	$SelectionWindow/Col2/Control.rect_min_size = Vector2(404, 62 * num_craftable + 4)
	if num_craftable == 0:
		var NoCraftLabel = Label.new()
		NoCraftLabel.text = "No armor available for synthesis."
		$SelectionWindow/Col2/Control.add_child(NoCraftLabel)

func show_detail(item, recipe):
	clear_detail()
	$Default.visible = false;
	var synth_detail_res = load("res://SynthDetail.tscn")
	var SynthDetail = synth_detail_res.instance()
	SynthDetail.name = "SynthDetail"
	SynthDetail.get_node("Name").text = item[2]
	
	var stat_string = ""
	var add_comma = false
	for i in len(item[1]): # item[1] is the stat array for the item
		if item[1][i] != 0:
			stat_string += ", " if add_comma else ""
			stat_string += Global.stat_names[i] + " "
			stat_string += "+" if item[1][i] > 0 else ""
			stat_string += str(item[1][i])
			add_comma = true
	SynthDetail.get_node("Stats").text = stat_string
	
	if item[0] == Weapon:
		var skill_string = "Skill: "
		add_comma = false
		for skill in item[3]:
			skill_string += ", " if add_comma else ""
			skill_string += skill.s_name
			add_comma = true
		SynthDetail.get_node("SkillAffinity").text = skill_string
	
	else:
		var aff_string = "Affinities: "
		var weak = []
		var nullify = []
		var resist = []
		for j in range(len(item[3])):
			if item[3][j] == 0:
				nullify.append(Global.element_names[j])
			elif item[3][j] > 1:
				weak.append(Global.element_names[j])
			elif item[3][j] < 1:
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
		SynthDetail.get_node("SkillAffinity").text = aff_string
	
	var synth_valid = true
	var mat_string = ""
	for mat in recipe:
		mat_string += Global.material_names[mat[0]] + " " + str(materials[mat[0]]) + "/" + str(mat[1]) + "\n"
		if synth_valid and materials[mat[0]] < mat[1]:
			synth_valid = false
	SynthDetail.get_node("Materials").text = mat_string
	
	if synth_valid:
		SynthDetail.get_node("Synthesize").disabled = false
		SynthDetail.get_node("Synthesize").connect("pressed", self, "perform_synthesis", [item, recipe])
	
	$SynthWindow.add_child(SynthDetail)

func perform_synthesis(item, recipe):
	if len(inventory) < 24:
		if item[0] == Weapon:
			inventory.append(Weapon.new(item[1], item[2], item[3], item[4]))
		else:
			inventory.append(Armor.new(item[1], item[2], item[3]))
		for mat in recipe:
			materials[mat[0]] -= mat[1]
		$Message/Label.text = "* Successfully synthesized a " + item[2] + "!"
	else:
		$Message/Label.text = "* Inventory too full to perform synthesis."
	clear_detail()

func clear_detail():
	$Default.visible = true
	for node in $SynthWindow.get_children():
		node.queue_free()

func _on_Return_pressed():
	get_parent().clear_synthesis()
