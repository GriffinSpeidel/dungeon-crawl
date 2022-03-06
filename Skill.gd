extends Node

class_name Skill

var s_name
var might
var element
var status
var hit
var crit
var target
var m_cost
var h_cost

enum {NONE, POISON, PARALYSIS}
enum {SINGLE, RANDOM, ALL}

func get_stats():
	return [might, element, hit, crit, h_cost, m_cost]

func _init(n, m, e, s, h, c, t, m_c, h_c):
	s_name = n
	might = m
	element = e
	status = s
	hit = h
	crit = c
	target = t
	m_cost = m_c
	h_cost = h_c
