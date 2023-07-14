extends HBoxContainer

@onready var icon_scene = preload("res://TurnIconUI.tscn")

# turn_container = TurnContainer object
func draw_turns(turn_container:TurnContainer):
	var children = self.get_children()
	var count = self.get_child_count()
	
	# clear all children from this display
	for i in range(count):
		self.remove_child(children[i])
	
	# now draw our turns from our turn container
	for turn in turn_container.turns:
		var icon = icon_scene.instantiate()
		self.add_child(icon)
		
		# we can only edit the icon after it's
		# entered the scene tree
		if(turn == turn_container.HALF):
			icon.set_half_icon()
	
