extends Node

var damage_scale = 3
var rand = RandomNumberGenerator.new()
enum {PHYS, FIRE, ICE, LIT, WIND}
var stat_names = ["Str", "Dex", "Vit", "Int", "Wis", "Luk"]
var element_names = ["Physical", "Fire", "Ice", "Lightning", "Wind"]
var encounter_rate_scale = 0.5

var lunge = Skill.new("Lunge", 1.3, PHYS, Skill.NONE, .75, .5, Skill.SINGLE, 0, 0.25)
var feuer = Skill.new("Feuer", 1.3, FIRE, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var eis = Skill.new("Eis", 1.3, ICE, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var blitz = Skill.new("Blitz", 1.3, LIT, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var sturm = Skill.new("Sturm", 1.3, WIND, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)

var eviscerate = Skill.new("Eviscerate", 1.6, PHYS, Skill.NONE, .75, .6, Skill.SINGLE, 0, 0.35)
var feuer_ex = Skill.new("Feuer EX", 1.6, FIRE, Skill.NONE, .9, 0, Skill.SINGLE, 8, 0)
var eis_ex = Skill.new("Eis EX", 1.6, ICE, Skill.NONE, .9, 0, Skill.SINGLE, 8, 0)
var blitz_ex = Skill.new("Blitz EX", 1.6, LIT, Skill.NONE, .9, 0, Skill.SINGLE, 8, 0)
var sturm_ex = Skill.new("Sturm EX", 1.6, WIND, Skill.NONE, .9, 0, Skill.SINGLE, 8, 0)

var eviscerate_cheap = Skill.new("Eviscerate", 1.6, PHYS, Skill.NONE, .75, .6, Skill.SINGLE, 0, 0.15)
var feuer_ex_c = Skill.new("Feuer EX", 1.6, FIRE, Skill.NONE, .9, 0, Skill.SINGLE, 1, 0)
var eis_ex_c = Skill.new("Eis EX", 1.6, ICE, Skill.NONE, .9, 0, Skill.SINGLE, 1, 0)
var blitz_ex_c = Skill.new("Blitz EX", 1.6, LIT, Skill.NONE, .9, 0, Skill.SINGLE, 1, 0)
var sturm_ex_c = Skill.new("Sturm EX", 1.6, WIND, Skill.NONE, .9, 0, Skill.SINGLE, 1, 0)

var smite = Skill.new("Divine Smite", 2.3, PHYS, Skill.NONE, 1, .5, Skill.SINGLE, 16, 0)

var material_names = ["Floating Fabric", "Sharp Tooth", "Rancid Sludge", "Cool Herb", "Food Scraps", "Rough Debris", "Liquid Asbestos", "Scratchy Wool", "Stretchy Skin", "Fig Leaf", "Raw Materials"]

#var bat = Weapon.new([2,0,0,0,0,0], "Baseball Bat", [lunge], [20])
#var knife = Weapon.new([1,1,0,0,0,0], "Pocket Knife", [feuer], [20])
#var icebox = Weapon.new([1,0,0,1,0,0], "Mini Icebox", [eis], [20])
#var vacuum = Weapon.new([1,0,1,0,0,0], "Vacuum Cleaner", [sturm], [20])
#var power_strip = Weapon.new([0,0,0,1,1,0], "Power Strip", [blitz], [20])
#var club = Weapon.new([3,-1,1,0,0,0], "Spiked Club", [], [])
#var sword = Weapon.new([2,2,0,0,0,0], "Ceramic Sword", [], [])
#var freezer = Weapon.new([1,0,2,0,1,0], "Freezer", [], [])
#var leaf_blower = Weapon.new([2,0,2,0,0,0], "Leaf Blower", [], [])
#var tesla = Weapon.new([-1,0,-1,3,2,0], "Tesla Coil", [], [])
#var excalibur = Weapon.new([2,2,2,2,2,10], "Excalibur", [], [])
