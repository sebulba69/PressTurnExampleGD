extends Skill

# skill that pass your turn
class_name PassSkill

func _init():
	super._init("Pass", false, true, false, 1)

# use this skill on the supplied target
# this function is only called if the skill hits
func use_skill(target:Battler) -> int:
	var turn_result = TurnResult.new()
	return turn_result.PASS
