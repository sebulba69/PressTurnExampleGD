# simple class containing possible results from a skill being used
# you can convert this to a global set of variables if you so choose
# these values will be used by the code to determine how many turns get
# depleted for an action
class_name TurnResult

# the following values are ordered by priority
# the higher the number, the higher priority they have over the other results
const PASS = 6
const REPEL = 5
const DRAIN = 4
const VOID_EVASION = 3
const WEAK_CRIT = 2
const NEUTRAL_RESIST = 1




