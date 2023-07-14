class_name TurnContainer

# possible turn icon values
const HALF = 1
const FULL = 2

# array of turn icons
var turns = []

# initialize the TurnContainer with the number of 
# turns you want to have. this should only be called
# when resetting this container
func init_turns(num_turns:int):
	for i in range(num_turns):
		self.turns.append(self.FULL)
		
# use a full turn
# always remove the first turn in the array
# this is true for half turns, full turns just
# consume whatever's there
func full_turn():
	self.turns.remove_at(0)

# weaknesses take the first full turn and
# turn it into a half turn. if no full turns
# remain, just consume a full turn like normal
func half_turn_weakness():
	var full_turn_index = find_first_full_turn()
	if(full_turn_index < 0):
		full_turn() # consume the first turn in the array
	else:
		self.turns[full_turn_index] -= self.HALF

# half turns (during passes) attempt to take half 
# of the turn at the front of the array. if it can't,
# then it'll consume the whole turn
func half_turn_pass():
	self.turns[0] -= self.HALF
	if(self.turns[0] == 0):
		full_turn()

# evading an attack or hitting an element
# someone is void to consumes two full press turns
func evasion_or_void():
	var num_turns_removed = 0
	
	# while we haven't removed 2 turns yet and
	# our turn array still has turns that can be removed
	while(num_turns_removed < 2 and !self.is_empty()):
		full_turn()
		num_turns_removed += 1

# drains or repels use all press turns
func drain_or_repel():
	self.turns = []

# check to see if the turn array is empty
# should be used by 
func is_empty():
	return self.turns.size() == 0

# find the index of the first full turn icon
func find_first_full_turn():
	var index = -1
	for i in range(self.turns.size()):
		if(self.turns[i] == self.FULL):
			index = i
			break
	return index
