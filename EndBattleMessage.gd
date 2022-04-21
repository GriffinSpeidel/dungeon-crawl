extends ReferenceRect

var lines = []

func _ready():
	for i in range(15):
		lines.append("")

func clear_messages():
	lines = []
	for i in range(15):
		lines.append("")
	add_message("Battle start!")

func add_message(message):
	var push_back = true
	for i in len(lines):
		if lines[i] == "":
			lines[i] = "* " + message
			push_back = false
			break
	if push_back:
		for i in range(14):
			lines[i] = lines[i + 1]
		lines[14] = "* " + message
	
	var label_text = ""
	for line in lines:
		label_text += line + '\n'
	$Label.set_text(label_text)
