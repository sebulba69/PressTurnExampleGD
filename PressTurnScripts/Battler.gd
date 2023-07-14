# player/enemy class (you can extend from this if you want to customize these)
class_name Battler

var name:String
var hp:HP # HP helper class
var resistances:Resistances # their resistances
var turns:int # the number of turns this entity has
var skills:Array # array of Skills

func _init(name:String, hp:HP, resistances:Resistances, skills:Array, turns:int = 1):
	self.name = name
	self.hp = hp
	self.resistances = resistances
	self.skills = skills
	self.turns = turns
