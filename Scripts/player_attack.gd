extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var growing_speed = .3
export var start_size = 0
export var team_id = 0
var timer
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	timer = get_node("Timer")
	self.scale.x = start_size
	self.scale.y = start_size
	print(team_id)

func _process(delta):
	if timer.time_left == 0:
		queue_free()
	self.scale.x += growing_speed
	self.scale.y += growing_speed
