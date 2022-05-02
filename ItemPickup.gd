extends Area

export(String) var g_name
export(int) var potency
export(int) var variety
export(bool) var full
var item

func _ready():
	item = Consumeable.new(g_name, potency, variety, full)
