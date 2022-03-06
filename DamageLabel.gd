extends RichTextLabel

func _init(hit, damage, element, crit, affinity, position):
	if hit:
		bbcode_text = "[color=#707070]"
		if crit:
			bbcode_text += "CRIT! "
		if affinity > 2:
			bbcode_text += "WEAK! "
		elif affinity < 1:
			bbcode_text += "RESIST! "
		bbcode_text += damage + "[/color]"
		rect_position = position
	else:
		bbcode_text = "[color=#707070]MISS[/color]"


func _on_Timer_timeout():
	queue_free()
