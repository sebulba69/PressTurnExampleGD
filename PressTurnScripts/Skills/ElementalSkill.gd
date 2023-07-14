extends Skill

# damage dealing skill
class_name ElementalSkill

var element:int
var damage:int

func _init(name:String, is_multihit:bool, number_of_uses:int, element:int, damage:int):
	super._init(name, is_multihit, true, true, number_of_uses) # this skill will always target the opposite side of whoever uses it
	self.element = element
	self.damage = damage

# use this skill on the supplied target
# this function is only called if the skill hits
func use_skill(target:Battler) -> int:
	var result = -1
	var turn_result = TurnResult.new()
	var resistances = target.resistances
	
	var crit = randi_range(1,100)
	var result_damage = self.damage
	
	# for this example, you will not deal criticals
	# if you do, it gets treated like a weakness
	# you can also remove this if you like
	if(crit == 0):
		result_damage = result_damage * 1.5
		result = turn_result.WEAK_CRIT
	if(resistances.is_repel(self.element)):
		result = turn_result.REPEL
	elif(resistances.is_drain(self.element)):
		result = turn_result.DRAIN
		target.hp.increase_HP(result_damage)
	elif(resistances.is_block(self.element)):
		result = turn_result.VOID_EVASION
	elif(resistances.is_resist(self.element)):
		# we specify this here because resists ALWAYS take priority over weaknesses
		# if the target is covering a weakness with a resist, we want to check that first
		result = turn_result.NEUTRAL_RESIST
		target.hp.reduce_HP(result_damage * 0.75)
	elif(resistances.is_weak(self.element)):
		result = turn_result.WEAK_CRIT
		# note: crits stack with weaknesses in this setup
		target.hp.reduce_HP(result_damage * 1.5)
	else:
		result = turn_result.NEUTRAL_RESIST
		target.hp.reduce_HP(result_damage)
	
	return result
		
