# a class for handling everything to do with the battlers during a battle
class_name PressTurnBattlers

var is_player_turn:bool

var players:Array # array of Battlers
var enemies:Array # array of Battlers

var active_battlers:Array # pointer to either the players or enemies
var active_index:int = 0 # index of the current active battler (used on active_battlers array only)

func _init(players:Array, enemies:Array, is_player_turn:bool = true):
	self.players = players
	self.enemies = enemies
	self.is_player_turn = is_player_turn
	set_active_battlers()

# swap turns from players to enemies or vise versa
func swap_turns():
	self.is_player_turn = !self.is_player_turn
	set_active_battlers()

func set_active_battlers():
	if(self.is_player_turn):
		active_battlers = self.players
	else:
		active_battlers = self.enemies

# find the next possible active battler, do not call this if everyone on one side is dead
# or the turn has ended
func find_next_active() -> Battler:
	# increment once to move past the last battler we were on
	increment_active_index()
	
	# look through all our battlers until we find an alive one
	while(!self.active_battlers[self.active_index].hp.is_alive):
		increment_active_index()
	
	return self.get_active()

# get the current active battler (can be called as a standalone function)
func get_active() -> Battler:
	return self.active_battlers[self.active_index]

# helper function for traversing the active array
func increment_active_index():
	self.active_index += 1
	if(self.active_index >= self.active_battlers.size()):
		self.active_index = 0

# get possible targets based on the skill (includes dead members)
func get_possible_targets(skill_targets_opposite:bool) -> Array:
	var targets = []
	if(self.is_player_turn):
		if(skill_targets_opposite):
			targets = self.enemies
		else:
			targets = self.players
	else:
		if(skill_targets_opposite):
			targets = self.players
		else:
			targets = self.enemies
	return targets

# get the turns for all active, alive members
func get_active_turns() -> int:
	var turns = 0
	
	for battler in self.active_battlers:
		if(battler.hp.is_alive):
			turns += battler.turns
	
	return turns

# alive checks to be done after each skill usage to see if anybody won
func check_alive_players() -> bool:
	return check_alive_battlers(self.players)

func check_alive_enemies() -> bool:
	return check_alive_battlers(self.enemies)

func check_alive_battlers(battlers:Array) -> bool:
	var alive = 0
	for battler in battlers:
		if(battler.hp.is_alive):
			alive += 1
	
	return alive > 0
