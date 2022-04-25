extends Control

var materials

var names = [
	"Floating Fabric", "Sharp Tooth", "Rancid Sludge", "Cool Herb",
	"Food Scraps", "Rough Debris", "Liquid Asbestos", "Scratchy Wool",
	"Stretchy Skin", "Fig Leaf", "Raw Materials"
]

var weapon_recipes = [
	[[Weapon, [2,0,0,0,0,0], "Baseball Bat", [Global.lunge], [20]],
	[[4, 2], [5, 2], [10, 2]]], # 2 food scrap, 2 debris, 2 raw materials
	[[Weapon, [1,1,0,0,0,0], "Knife", [Global.feuer], [20]],
	[[1, 2], [10, 2]]], # 2 teeth, 2 raw materials
	[[Weapon, [1,0,0,1,0,0], "Icebox", [Global.eis], [20]],
	[[3, 2], [10, 2]]], # 2 cool herb, 2 raw materials
	[[Weapon, [0,0,0,1,1,0], "Power Strip", [Global.blitz], [20]],
	[[2, 2], [10, 2]]], # 2 sludge, 2 raw materials
	[[Weapon, [1,0,1,0,0,0], "Vacuum", [Global.sturm], [20]],
	[[0, 2], [10, 2]]] # 2 floating fabric, 2 raw materials
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

func _initialize(materials):
	self.materials = materials
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
				mat_list_string += names[mat[0]] + " x" + str(mat[1]) + "\n"
			SynthBox.get_node("ReferenceRect/Materials").text = mat_list_string
			
			SynthBox.rect_position = Vector2(1, 62 * num_craftable + 1)
			$SelectionWindow/Col1/Control.add_child(SynthBox)
			
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
				mat_list_string += names[mat[0]] + " x" + str(mat[1]) + "\n"
			SynthBox.get_node("ReferenceRect/Materials").text = mat_list_string
			
			SynthBox.rect_position = Vector2(1, 62 * num_craftable + 1)
			$SelectionWindow/Col2/Control.add_child(SynthBox)
			
			num_craftable += 1
	$SelectionWindow/Col2/Control.rect_min_size = Vector2(404, 62 * num_craftable + 4)
	if num_craftable == 0:
		var NoCraftLabel = Label.new()
		NoCraftLabel.text = "No armor available for synthesis."
		$SelectionWindow/Col2/Control.add_child(NoCraftLabel)
