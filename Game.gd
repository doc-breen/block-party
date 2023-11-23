extends Node2D

onready var game_timer:= $GameTimer
const SCREEN_WIDTH = 350
const SCREEN_HEIGHT = 800
const SCREEN_BUFFER = 30
var level: int = 1
var per_level_quant: int = 2
const Block = preload("res://Block.tscn")
var block_array:= []
signal wipe_blocks
onready var timer_label:= $Control/HBoxContainer/TimeCount
onready var level_label:= $Control/HBoxContainer/LevelCount
onready var bing_sound:= $Bing
onready var loss_sound:= $Fail


func _ready():
# warning-ignore:return_value_discarded
	game_timer.connect("timeout",self,"_on_GameTimer_timeout")
	# Spawn blocks
	new_block_wave(level)
	game_timer.start()


func _process(_delta):
	timer_label.text = String(int(game_timer.time_left)+1)
	
	level_label.text = String(level)


func new_block_wave(level_num: int):
	var num_blocks = level_num*per_level_quant
	for i in range(0,num_blocks):
		var block = Block.instance()
		var rand_pos = Vector2(rand_range(SCREEN_BUFFER,SCREEN_WIDTH-SCREEN_BUFFER),rand_range(SCREEN_BUFFER+100,SCREEN_HEIGHT-SCREEN_BUFFER))
		block.position = rand_pos
		add_child(block)
		block_array.append(i)


func level_up() -> void:
	# New level
		level += 1
		new_block_wave(level)
		game_timer.start(5)
		# Reset pitch
		bing_sound.pitch_scale = 1.0


func on_block_dropped():
	# Remove block from array
	block_array.pop_back()
	# Play sound and increase pitch
	bing_sound.play()
	bing_sound.pitch_scale += 0.05
	# Level up when all blocks are wiped
	if block_array == []:
		yield(get_tree().create_timer(.25),"timeout")
		level_up()
	

func _on_GameTimer_timeout():
	loss_sound.play()
	# end game
	emit_signal("wipe_blocks")
	timer_label.text = String(0)
	$Popup/VBoxContainer/VarLabel.text = "Level " + String(level)
	$Popup.popup()
	get_tree().paused = true


func _on_RetryButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().paused = false
	get_tree().reload_current_scene()
