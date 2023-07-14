extends Node2D

var container_UI
var turn_label:Label
var result_label:Label
var enemy_hp_nodes:Dictionary
var target_list

var press_turn:PressTurn

var rock_button
var paper_button
var scissors_button
var rock_all_button
var pass_button

func _ready():
	self.container_UI = get_node("%TurnContainerUI")
	self.turn_label = get_node("%TurnLabel")
	self.result_label = get_node("%ResultLabel")
	self.target_list = get_node("%TargetList")
	
	self.rock_button = get_node("%RockButton")
	self.paper_button = get_node("%PaperButton")
	self.scissors_button = get_node("%ScissorsButton")
	self.rock_all_button = get_node("%RockAllButton")
	self.pass_button = get_node("%PassButton")
	
	var elements = Elements.new()
	
	var rock = ElementalSkill.new("Rock", false, 1, elements.ROCK, 10)
	var paper = ElementalSkill.new("Paper", false, 1, elements.PAPER, 10)
	var scissors = ElementalSkill.new("Scissors", false, 1, elements.SCISSORS, 10)
	var rock_all = ElementalSkill.new("Rock All", true, 1, elements.ROCK, 10)
	
	var skills = [rock, paper, scissors, rock_all, PassSkill.new()]
	
	# (weak, resist, block, drain, repel)
	var rock_peter = Resistances.new([elements.PAPER], [], [elements.SCISSORS])
	var paper_peter = Resistances.new([elements.SCISSORS], [], [], [], [elements.ROCK])
	var scissors_peter = Resistances.new([elements.ROCK], [elements.SCISSORS])
	var me = Resistances.new()
	
	var rhp = HP.new(500)
	var php = HP.new(500)
	var shp = HP.new(500)
	var myHP = HP.new(500)
	
	# (hp:HP, resistances:Resistances, skills:Array, turns:int = 1)
	var rockp = Battler.new("Rock Peter", rhp, rock_peter, [rock])
	var paperp = Battler.new("Paper Peter", php, paper_peter, [paper])
	var scissp = Battler.new("Scissors Peter", shp, scissors_peter, [scissors])
	
	# sample dictionary just so I can quickly update the UI with my UI result
	self.enemy_hp_nodes = {
		rockp:get_node("%RockHP"),
		paperp:get_node("%PaperHP"),
		scissp:get_node("%ScissorsHP")
	}
	
	var mePlayer = Battler.new("Me", myHP, me, skills, 4)
	
	var players = [mePlayer]
	var enemies = [rockp, paperp, scissp]
	
	for i in range(enemies.size()):
		var enemy = enemies[i]
		self.enemy_hp_nodes[enemy].text = "HP: " + enemy.hp.get_hp_string()
	
	# (players:Array, enemies:Array, player_turn:bool = true)
	self.press_turn = PressTurn.new(players, enemies)
	self.press_turn.start_turn()
	self.container_UI.draw_turns(self.press_turn.container)
	self.turn_label.text = "Player Turn"
	self.populate_target_list(0)
	self.target_list.select(0)

func _on_rock_button_pressed():
	use_skill_at_index(0)

func _on_paper_button_pressed():
	use_skill_at_index(1)

func _on_scissors_button_pressed():
	use_skill_at_index(2)

func _on_rock_all_button_pressed():
	use_skill_at_index(3)

func _on_pass_button_pressed():
	use_skill_at_index(4)

func use_skill_at_index(index:int):
	var target = self.target_list.get_selected_items()
	if(target.size() > 0):
		var t_index = target[0]
		var update = self.press_turn.use_skill(index, t_index)
		update_ui(update)
		
	# enemy turn stuff goes here
	# for this example, the enemies won't do anything
	# you will probably want to customize this with your own functionality for enemies
	if(!self.press_turn.check_if_player_turn()):
		change_buttons_enabled(false)
		
		self.container_UI.draw_turns(self.press_turn.container)
		self.turn_label.text = "Doing fake enemy turn brrr..."
		var timer = get_node("%EnemyTurnTimer")
		timer.start()
		await timer.timeout
		
		# fake update just to force things back to the player
		var example_update = UIResult.new(null)
		
		# the following is just for the sake of moving this
		# example along, you shouldn't do this in your game
		self.press_turn.container.drain_or_repel()
		update_ui(example_update)
		self.container_UI.draw_turns(self.press_turn.container)
		change_buttons_enabled(true)
		self.turn_label.text = "Player Turn"

func change_buttons_enabled(enabled:bool):
	self.rock_button.disabled = !enabled
	self.paper_button.disabled = !enabled
	self.scissors_button.disabled = !enabled
	self.rock_all_button.disabled = !enabled
	
func _on_rock_button_mouse_entered():
	populate_target_list(0)

func _on_paper_button_mouse_entered():
	populate_target_list(1)

func _on_scissors_button_mouse_entered():
	populate_target_list(2)

func populate_target_list(skill_index:int):
	if(!self.press_turn.check_if_player_turn()):
		return
		
	var selected = self.target_list.get_selected_items()
	
	self.target_list.clear()
	var targets = self.press_turn.get_targets_for_skill(skill_index)
	for target in targets:
		target_list.add_item(target.name)
	
	if(selected.size() > 0):
		var index = selected[0]
		if(index >= target_list.item_count):
			index = target_list.item_count - 1
		target_list.select(index)

# update the UI after a skill finishes
func update_ui(ui_update:UIResult):
	# update HP
	for target in ui_update.targets:
		if(self.enemy_hp_nodes.has(target)):
			self.enemy_hp_nodes[target].text = "HP: " + target.hp.get_hp_string()
	
	self.result_label.text = "Result: " + get_example_skill_result(ui_update.skill_result)
	if(ui_update.user != null):
		self.result_label.text += " -- HP: " + ui_update.user.hp.get_hp_string()
	
	# update turns
	self.container_UI.draw_turns(self.press_turn.container)
	
	self.press_turn.do_post_turn_checks()

# purely for example purposes, just map the last action to a string value
# so you can understand what your skill did
func get_example_skill_result(result:int) -> String:
	var values = TurnResult.new()
	var example_dict = {
		values.PASS:"Pass",
		values.REPEL: "Repel",
		values.DRAIN: "Drain",
		values.VOID_EVASION: "Void/Evade",
		values.NEUTRAL_RESIST: "Neutral",
		values.WEAK_CRIT: "Weak/Crit",
		0: "None"
	}
	return example_dict[result]
