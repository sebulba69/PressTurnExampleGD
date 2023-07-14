extends TextureRect

# we use full icons by default, so I'm just preloading this graphic
# we can't go from half --> full
@onready var half_icon = preload("res://icon_graphics/half_icon.png")

func set_half_icon():
	self.texture = self.half_icon
