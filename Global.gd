extends Node

var damage_scale = 3
var rand = RandomNumberGenerator.new()
enum {PHYS, FIRE, ICE, LIT, WIND, HEAL}
var stat_names = ["Strength", "Dexterity", "Vitality", "Intelligence", "Wisdom", "Luck"]
var encounter_rate_scale = 0.5

var lunge = Skill.new("Lunge", 1.3, PHYS, Skill.NONE, .75, .5, Skill.SINGLE, 0, 0.25)
var feuer = Skill.new("Feuer", 1.3, FIRE, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var eis = Skill.new("Eis", 1.3, ICE, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var blitz = Skill.new("Blitz", 1.3, LIT, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var sturm = Skill.new("Sturm", 1.3, WIND, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)

#var bat = Weapon.new([2,0,0,0,0,0], "Baseball Bat", [lunge], [20])
#var knife = Weapon.new([1,1,0,0,0,0], "Pocket Knife", [feuer], [20])
#var icebox = Weapon.new([1,0,0,1,0,0], "Mini Icebox", [eis], [20])
#var vacuum = Weapon.new([1,0,1,0,0,0], "Vacuum Cleaner", [sturm], [20])
#var power_strip = Weapon.new([0,0,0,1,1,0], "Power Strip", [blitz], [20])
#var club = Weapon.new([3,0,1,0,0,0], "Spiked Club", [], [])
#var sword = Weapon.new([2,2,0,0,0,0], "Ceramic Sword", [], [])
#var freezer = Weapon.new([1,0,2,0,1,0], "Freezer", [], [])
#var leaf_blower = Weapon.new([2,0,2,0,0,0], "Leaf Blower", [], [])
#var tesla = Weapon.new([-1,0,-1,3,2,0], "Tesla Coil", [], [])
#var excalibur = Weapon.new([2,2,2,2,2,10], "Excalibur", [], [])
