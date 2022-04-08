extends Node

var damage_scale = 3
var rand = RandomNumberGenerator.new()
enum {PHYS, FIRE, ICE, LIT, WIND, HEAL}
var stat_names = ["Strength", "Dexterity", "Vitality", "Intelligence", "Wisdom", "Luck"]
var encounter_rate_scale = 1

var lunge = Skill.new("Lunge", 1.3, PHYS, Skill.NONE, .75, .5, Skill.SINGLE, 0, 0.25)
var feuer = Skill.new("Feuer", 1.3, FIRE, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var eis = Skill.new("Eis", 1.3, ICE, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var blitz = Skill.new("Blitz", 1.3, LIT, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
var sturm = Skill.new("Sturm", 1.3, WIND, Skill.NONE, .9, 0, Skill.SINGLE, 3, 0)
