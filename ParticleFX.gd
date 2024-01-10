extends Particles2D

const ANIM_TIME:= 1.5
var life_time:= 0

func _ready():
	pass


func _process(delta):
	life_time += delta
	if life_time >= ANIM_TIME:
		queue_free()
