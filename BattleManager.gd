extends Node

var encounter
signal end_battle
enum {PHYS}

func get_target():
	pass

func _ready():
	encounter = get_parent().get_parent().encounter

func _on_StrikeButton_pressed():
	var enemy_buttons = []
	$BattleMenu.hide()
	for i in range(len(encounter)):
		enemy_buttons.append(Button.new())
		enemy_buttons[i].rect_position = (Vector2(412 - 110 * (len(encounter) - 1) + i * 220, 350))
		enemy_buttons[i].rect_size = (Vector2(200, 50))
		enemy_buttons[i].mouse_default_cursor_shape = 2
		enemy_buttons[i].text = "Select " + encounter[i].type
		enemy_buttons[i].connect("pressed", self, "_on_EButton_pressed", [i, 1, PHYS]) # enemy selected, skill modifier, type
		add_child(enemy_buttons[i])


func _on_SkillButton_pressed():
	pass # Replace with function body.


func _on_GuardButton_pressed():
	pass # Replace with function body.


func _on_FleeButton_pressed():
	emit_signal("end_battle")

func _on_EButton_pressed(i, scale, element):
	print()
