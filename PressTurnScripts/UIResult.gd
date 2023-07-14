# this is a class that'll tell your UI what to show the player
# you can customize this class based on whatever effects you want
# to show up on screen
class_name UIResult

# the user of the skill
var user:Battler

# targets affected by the skill
var targets:Array

# a flag for whether or not a skill was cast (could be due to no legal targets)
var skill_cast_successfully:bool

var skill_result:int

func _init(user:Battler):
	self.user = user
	self.targets = []
	self.skill_cast_successfully = true
