class_name PressTurn

signal battle_ended(players_won:bool)

var battlers:PressTurnBattlers
var container:TurnContainer
var result_values:TurnResult # easy access reference to compare turn values

func _init(players:Array, enemies:Array, player_turn:bool = true):
	self.battlers = PressTurnBattlers.new(players, enemies, player_turn)
	self.container = TurnContainer.new()
	self.result_values = TurnResult.new()

# init turns
func start_turn():
	self.container.init_turns(self.battlers.get_active_turns())

# end the current turn and set up the turns for the next one
# this should not be called if the battle's ended
func end_turn():
	self.battlers.swap_turns()
	start_turn()

# do all checks to see if the battle should keep going
func do_post_turn_checks():
	if(!self.battlers.check_alive_enemies()):
		battle_ended.emit(true) # if there are no enemies left, players won
	elif(!self.battlers.check_alive_players()):
		battle_ended.emit(false) # if there are no players left, enemies won
	else:
		if(self.container.is_empty()):
			end_turn() # swap turns if we're out of turns

func check_if_player_turn() -> bool:
	return self.battlers.is_player_turn

# returns an array of Battlers that are affected by the skill
func get_targets_for_skill(skill_index:int) -> Array:
	var skill = self.get_active_skill(skill_index)
	return self.battlers.get_possible_targets(skill.targets_enemies)

func use_skill(skill_index:int, target_index:int) -> UIResult:
	var ui_result = UIResult.new(self.battlers.get_active()) 	# our GUI result that'll show all the fancy effects to the player

	var skill = self.get_active_skill(skill_index)
	var targets = self.battlers.get_possible_targets(skill.targets_enemies)

	# the skill must be processed differently based on whether or not it's multihit
	if(!skill.is_multihit):
		var target = targets[target_index]
		
		# if the target must be alive for the skill to work, we don't want to use the skill
		if(skill.target_must_be_alive and !target.hp.is_alive):
			ui_result.skill_cast_successfully = false 
		else:
			var result = self.get_result_from_skill(skill, target, ui_result)
			ui_result.skill_result = result
			self.process_result_turns(result)

	else:
		# with multihit skills, we only want to process the turn result that we deem
		# most valuable. this is determined by the order of the numbers (from highest to lowest)
		# in TurnResult
		var result_final = -1

		for target in targets:
			if(skill.target_must_be_alive and target.hp.is_alive):
				ui_result.targets.append(target)
				
				var result = self.get_result_from_skill(skill, target, ui_result)
				# keep the highest priority result
				if(result > result_final):
					result_final = result
		
		# there were no valid targets to use the skill on
		# it's extremely unlikely this will happen, but this accounts
		# for this scenario
		if(result_final == -1):
			ui_result.skill_cast_successfully = false
		else:
			ui_result.skill_result = result_final
			self.process_result_turns(result_final)
	
	return ui_result


func get_result_from_skill(skill:Skill, target:Battler, ui_result:UIResult) -> int:
	# miss by default
	var result = self.result_values.VOID_EVASION
	var hit = randi_range(1,100)
			
	# for this example, we have a 100% hit rate. you can change this
	# to be whatever you want in your game
	if(hit <= 100):
		for i in range(skill.number_of_uses):
			result = skill.use_skill(target)
			if(result == self.result_values.REPEL):
				var active = self.battlers.get_active()
				skill.use_skill(active)
				ui_result.targets.append(active) # if we got a repel, we want the UI to show you getting hit
				break
			else:
				ui_result.targets.append(target)
			
			if(result == self.result_values.DRAIN):
				break
			
	return result

func process_result_turns(result:int):
	if(result == self.result_values.REPEL or result == self.result_values.DRAIN):
		self.container.drain_or_repel()
	elif(result == self.result_values.VOID_EVASION):
		self.container.evasion_or_void()
	elif(result == self.result_values.WEAK_CRIT):
		self.container.half_turn_weakness()
	elif(result == self.result_values.PASS):
		self.container.half_turn_pass()
	else:
		self.container.full_turn()

# get the skill of the active player at the provided index
func get_active_skill(skill_index:int) -> Skill:
	var active = self.battlers.get_active()
	var skill = active.skills[skill_index]
	return skill
