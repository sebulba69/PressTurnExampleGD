class_name HP

var hp:int
var max_hp:int
var is_alive:bool = true

func _init(starting_hp:int):
	self.hp = starting_hp
	self.max_hp = starting_hp

func increase_HP(amount:int):
	hp += amount
	if(hp >= max_hp):
		hp = max_hp

func reduce_HP(amount:int):
	hp -= amount
	if(hp <= 0):
		hp = 0
		is_alive = false

func get_hp_string():
	return str(hp) + "/" + str(max_hp)
