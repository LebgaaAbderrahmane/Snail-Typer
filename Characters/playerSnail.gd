extends CharacterBody2D

@onready var spotList = ["river1", "river2", "river3"]
@onready var curInt: int = 0
@onready var curSpot = spotList[curInt]
	
func _input(event):
	if event.is_action_pressed("move_up"): 
		if curSpot != spotList[0]: 
			curInt -= 1
			curSpot = spotList[curInt]
			
	elif event.is_action_pressed("move_down"): 
		if curSpot != spotList[len(spotList)-1]: 
			curInt += 1
			curSpot = spotList[curInt]
			
	#sets user position to that of current spot plus an offset for text collisions	
	self.position = Vector2(get_parent().get_node(curSpot).position.x + 60, get_parent().get_node(curSpot).position.y + 80) 

func get_cur_river() -> int: 
	return curInt
