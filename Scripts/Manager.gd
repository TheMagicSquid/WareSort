extends Node2D

var dropoff
var pickup
var customerDisplay
var boxes
var camera

var complete
var start
var woosh
var fail
var clock
var forklift

var scene

var dropoffRect

var tutorialTime = true
var speedUp = 0.07
var timer = 0
var switchState = "Receive"

var active = false
var selectebox = null

var orders = []
var imageRender = []

func _ready():
	dropoff = get_node("Customer")
	pickup = get_node("Delivery")
	customerDisplay = get_node("Customer Display")
	boxes = get_node("../BoxList")
	camera = get_node("../Camera2D")
	dropoffRect = Rect2(dropoff.global_position, dropoff.size)
	
	complete = get_node("Complete")
	start = get_node("Start")
	woosh = get_node("Woosh")
	fail = get_node("Fail")
	clock = get_node("Clocktick")
	forklift = get_node("Forklift")
	
	scene = preload("res://Scenes/box.tscn")


func _process(delta):
	if Global.paused:
		return
	if switchState == "Receive":
		if tutorialTime and Rect2(pickup.global_position, pickup.size).has_point(camera.global_position):
			timer += 2
			
		timer += speedUp
		CheckBoxes()
		if timer > 85 and not clock.is_playing() and Global.orders > 0:
			clock.play()
		if timer > 100:
			clock.stop()
			CheckForLoss(orders)
			AddNewBoxes()
			orders = Order(floor(sqrt(Global.orders+1)*4/3)+1)
			Deliver(orders)
			speedUp = sqrt(speedUp/10)+floor(Global.orders/8)/20
			switchState = "Sell"
			Global.orders += 1
			timer = 0
			if not forklift.is_playing():
				forklift.play()
	else:
		if tutorialTime and dropoffRect.has_point(camera.global_position):
			timer += 2
		
		timer += 0.07
		if timer > 15:
			forklift.stop()
			
		if timer > 100:
			if not complete.is_playing():
				complete.play()
			DisplayOrder(orders)
			switchState = "Receive"
			tutorialTime = false
			timer = 0

func AddNewBoxes():
	var amountMissing = floor(sqrt(Global.orders+1)*4/3)-len(Global.iconTypes)+3
	if amountMissing == 0:
		return
	for i in amountMissing:
		var random = Global.allIconTypes.pick_random()
		if random == null:
			return
		Global.allIconTypes.erase(random)
		Global.iconTypes.append(random)
		print(Global.iconTypes)
		print(Global.allIconTypes)
	
func CheckBoxes():
	if Global.draggingid != null:
		selectebox = Global.draggingid
		active = true
	elif active:
		if dropoffRect.has_point(selectebox.position):
			CollectBox(selectebox)
		selectebox = null
		active = false
			
func CollectBox(box):
	var failure = true
	for i in len(orders):
		if orders[i][1].has(box.type):
			orders[i][1].remove_at(orders[i][1].find(box.type))
			if len(orders[i][1]) == 0:
				orders.remove_at(i)
				if not woosh.is_playing():
					woosh.play()
			else:
				if not start.is_playing():
					start.play()
			failure = false
			break
	if failure:
		fail.play()
	box.queue_free()
	DisplayOrder(orders)
			
func DisplayOrder(orrdder):
	for render in imageRender:
		render.queue_free()
	imageRender = []
	
	var count = 0
	for ord in orrdder:
		var leng = len(ord[1])
		var posx = 40*(2*count+leng)
		var posy = 256/3
		renderImage("Characters/"+ord[0], Vector2(posx, posy), Vector2(0.5, 0.5))
		for i in range(leng):
			posx = 80*(0.5+i+count)
			renderImage("Icons/"+ord[1][i], Vector2(posx, posy*2), Vector2(0.5, 0.5))
		count += leng+0.5

func Order(number):
	var count = 0
	var returnorder = []
	while count < number:
		var indieOrder = []
		var randy = randi_range(1, number-count)
		for i in range(randy):
			count += 1
			indieOrder.append(Global.iconTypes.pick_random())
		returnorder.append(["Aien", indieOrder])
	print(returnorder)
	return returnorder
	
func Deliver(neededDeliv):
	var numberOfOrders = 0
	for ordd in neededDeliv:
		for itemord in ordd[1]:
			Global.iconQueue.append(itemord)
			numberOfOrders += 1
			
	for i in range(numberOfOrders):
		Global.iconQueue.append(Global.iconTypes.pick_random())
		numberOfOrders += 1
		
	for i in range(numberOfOrders):
		var instance = scene.instantiate()
		boxes.add_child(instance)
		instance.position = findRandomPosition()
			
func findRandomPosition():
	for loop in range(0, 10):
		var localposition = Vector2(pickup.size.x*randf()*0.95+32, pickup.size.y*randf()*0.95)
		var trialposition = round((pickup.global_position+localposition)/64)*64
		var place = true
		for box in boxes.get_children():
			if box.global_position == trialposition:
				place = false
				break
		if place:
			return trialposition
	return "FAILURE"
	
func CheckForLoss(oderlist):
	if len(oderlist) > 0:
		Global.state = "overr"
		
func renderImage(path, pos, size):
	var sprite2d = Sprite2D.new()
	sprite2d.texture = load("res://"+path+".svg")
	sprite2d.scale = size
	sprite2d.position = pos
	imageRender.append(sprite2d)
	add_child(sprite2d)
