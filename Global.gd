extends Node

var score: int = 0
const bgm_track = preload("res://blockgroundmusic.wav")
onready var bgm:= AudioStreamPlayer.new()


func _ready():
	randomize()
	bgm.stream = bgm_track
	add_child(bgm)
	#bgm.connect("finished",self,"on_track_ended")
	bgm.play()


func on_score_increased():
	score += 1
