class_name Resistances

var weak = [] # elements the class owner is weak to
var resist = [] # elements the class owner resists
var block = [] # elements the class owner voids
var drain = [] # elements the class owner drains
var repel = [] # elements the class owner repels

func _init(weak:Array = [], resist:Array = [], block:Array = [], drain:Array = [], repel:Array = []):
	self.weak = weak
	self.resist = resist
	self.block = block
	self.drain = drain
	self.repel = repel

# for each check function, element comes from Elements
func is_weak(element:int):
	return self.weak.has(element)

func is_resist(element:int):
	return self.resist.has(element)

func is_block(element:int):
	return self.block.has(element)

func is_drain(element:int):
	return self.drain.has(element)

func is_repel(element:int):
	return self.repel.has(element)
