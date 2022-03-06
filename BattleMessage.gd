extends ReferenceRect

var lines = ["", "", "", ""]

func _ready():
	add_message("Battle start!")

func add_message(message):
	var push_back = true
	for i in len(lines):
		if lines[i] == "":
			lines[i] = "* " + message
			push_back = false
			break
	if push_back:
		for i in range(3):
			lines[i] = lines[i + 1]
		lines[3] = "* " + message
	$Label.set_text(lines[0] + '\n' + lines[1] + '\n' + lines[2] + '\n' + lines[3])
