# base class for skills
class_name Skill

var name:String
var is_multihit:bool # does the skill affect multiple enemies?
var targets_enemies:bool # does this skill target the opposite of the current entity?
var target_must_be_alive:bool # does the target have to be alive for this skill to be usable?
var number_of_uses:int # how many times does the skill proc?

func _init(name:String, is_multihit:bool, targets_enemies:bool, target_must_be_alive:bool, number_of_uses:int):
	self.name = name
	self.is_multihit = is_multihit
	self.targets_enemies = targets_enemies
	self.target_must_be_alive = target_must_be_alive
	self.number_of_uses = number_of_uses

# base function that should be overrided by the skill's child classes
# all skills have a target, which is a battler
func use_skill(target:Battler) -> int:
	return -1
