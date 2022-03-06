extends Node

var paused = false
var char1
var char2
var char3
var box_res = load("res://EnemyBox.tscn")
var enemy_res = [preload("res://EnemyHead.tscn")]
var battle = false
var encounter = []
var party = []

func _ready():
	Global.rand.randomize()
	var character_resource = load("res://Character.tscn")
	char1 = character_resource.instance()
	party.append(char1)
	$PartyNode.add_child(char1)
	char1._initialize("foop", "res://textures/Face1.png")
	char1.learn_skill(Global.lunge)
	char1.learn_skill(Global.feuer)
	char1.learn_skill(Global.sturm)
	char1.learn_skill(Global.blitz)
	
	char2 = character_resource.instance()
	party.append(char2)
	$PartyNode.add_child(char2)
	char2._initialize("shoop", "res://textures/Face1.png")
	char2.learn_skill(Global.feuer)
	
	char3 = character_resource.instance()
	party.append(char3)
	$PartyNode.add_child(char3)
	char3._initialize("woop", "res://textures/Face1.png")
	char3.learn_skill(Global.eis)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and not battle:
		if paused:
			unpause()
		else:
			pause()

func _on_OfficeGrid_pickup():
	#$HUD/Label.text = "picked up"
	#var level = get_node("OfficeGrid")
	#$OfficeGrid.queue_free()
	#var next_level_resource = load("res://Office2.tscn")
	#var next_level = next_level_resource.instance()
	#add_child(next_level)
	#next_level.connect("pickup2", self, "_on_Office2_pickup")
	start_encounter()

func start_encounter():
	# fill encounter
	var encounter_res = [0, 0] # 0 Head, 
	encounter = []
	for i in range(len(encounter_res)):
		encounter.append(enemy_res[encounter_res[i]].instance())
		$Battle.add_child(encounter[i])
		encounter[i]._initialize(1)
		var box = box_res.instance()
		encounter[i].add_child(box)
		$Battle.update_enemy_health(encounter, i)
		encounter[i].get_child(0).rect_position = Vector2(412 - 110 * (len(encounter_res) - 1) + i * 220, 100)
	
	# begin battle
	battle = true
	$Battle._initialize(party, encounter)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Battle.show()

func _on_Office2_pickup():
	$HUD/Label.text = char1.get_name()

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	paused = true
	$Battle.hide()
	$PauseMenu.show()

func unpause():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	paused = false
	$PauseMenu.hide()

func _on_Unpause_button_down():
	$HUD/Label.text = "pressed unpause"
	unpause()

func _on_Battle_end_battle(manager_index):
	$HUD/Label.text = "fled"
	for e in encounter:
		e.queue_free()
	battle = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Battle.hide()
	$Battle.get_child(manager_index).queue_free()
