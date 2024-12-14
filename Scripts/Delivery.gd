extends ColorRect

var boxes
var timer = 0
var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	boxes = get_node("../BoxList")
	scene = preload("res://Scenes/box.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.paused:
		return
	#print(size)
	#print(position)
	timer += 0.1
	if timer > 100:
		deliveryTime()
		
func deliveryTime():
	for i in range(10):
		var instance = scene.instantiate()
		boxes.add_child(instance)
		instance.position = findRandomPosition();
	timer = 0
	
func findRandomPosition():
	for loop in range(0, 10):
		var localposition = Vector2(size.x*randf()*0.95+32, size.y*randf()*0.95)
		var trialposition = round((position+localposition)/64)*64
		var place = true
		for box in boxes.get_children():
			if box.position == trialposition:
				place = false
				break
		if place:
			return trialposition
	return "FAILURE"
