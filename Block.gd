extends Node2D


var block_color: Color
onready var buton:= $TextureButton
signal up_score
signal drop_block
signal explode(pos,col)
export var tap_health: int = 1
var tap_count: int = 0


func _ready():
	# warning-ignore:return_value_discarded
	buton.connect("pressed",self,"on_Button_pressed")
	# warning-ignore:return_value_discarded
	get_parent().connect("wipe_blocks",self,"on_game_end")
	block_color.r = rand_range(0,1)
	block_color.g = rand_range(0,1)
	block_color.b = rand_range(0,1)
	modulate = block_color
	# warning-ignore:return_value_discarded
	connect("up_score",Global,"on_score_increased")
	# warning-ignore:return_value_discarded
	connect("drop_block",get_parent(),"on_block_dropped")
	# warning-ignore:return_value_discarded
	connect("explode",get_parent(),"particles")


func on_Button_pressed():
	tap_count += 1
	# Show tap effects
	
	if tap_count == tap_health:
		# Remove block and increase score
		emit_signal("explode",self.position,self.modulate)
		emit_signal("up_score")
		emit_signal("drop_block")
		queue_free()


func on_game_end():
	# Remove block
	queue_free()
	
