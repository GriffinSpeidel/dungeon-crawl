extends Item

class_name CraftMaterial
var id

func _init(n, id): # id is specific to the type of material for the sake of crafting
	g_name = n
	type = 3
	self.id = id

# 00 - floating fabric (suit) - vacuum, fancy suit
# 01 - sharp tooth (head) - knife
# 02 - rancid sludge (ooze) - power strip
# 03 - cool herb (plant) - icebox
# 04 - food scraps (plant, ooze) - bat, bulletproof vest
# 05 - scattered debris (head, suit) - bat, bulletproof vest
# 06 - liquid asbestos (ooze) - asbestos cloak
# 07 - scratchy wool (suit) - winter coat
# 08 - stretchy skin (head) - rubber suit
# 09 - fig leaf (plant) - wind jacket
# 10 - raw materials - all
