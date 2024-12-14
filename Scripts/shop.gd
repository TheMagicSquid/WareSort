extends Node2D

var orders = [["Aien", ["icon"]], ["Aien", ["icon"]]]
var imageRender = []
var active = false
var selectebox = null
var score = 0

var rentTime = 0
var rentTimeInc = 0.05
var rentMoney = 50

var customer
var dropoff
var startaudio
var complaudio
var woosh

func _ready():
	woosh = get_node("Woosh")
	customer = get_node("Customer")
	startaudio = get_node("Start")
	complaudio = get_node("Complete")
	dropoff = Rect2(customer.global_position, customer.size)
	randomize()
	displayOrder()

func _process(delta):
	if Global.paused:
		return
	rentTime += rentTimeInc
	if rentTime > 100:
		rentTime = 0
		rentTimeInc = pow(rentTimeInc, 0.8)
		score -= rentMoney
		if score < 0:
			Global.state = "overr"
	if len(orders) == 0:
		updateOrder()
	if Global.draggingid != null:
		selectebox = Global.draggingid
		active = true
	elif active:
		if dropoff.has_point(selectebox.position):
			woosh.play()
			for i in len(orders):
				if orders[i][1].has(selectebox.type):
					orders[i][1].remove_at(orders[i][1].find(selectebox.type))
					if len(orders[i][1]) == 0:
						orders.remove_at(i)
						Global.orders += 1
						complaudio.play()
						score += 100
					displayOrder()
					break
			selectebox.queue_free()
		active = false
		selectebox = null
	
func displayOrder():
	for render in imageRender:
		render.queue_free()
	imageRender = []
	
	updateOrder()
	
	var count = 0
	for ord in orders:
		var leng = len(ord[1])
		var posx = 40*(2*count+leng)
		var posy = 256/3
		renderImage("Characters/"+ord[0], Vector2(posx, posy), Vector2(0.5, 0.5))
		for i in range(leng):
			posx = 80*(0.5+i+count)
			renderImage("Icons/"+ord[1][i], Vector2(posx, posy*2), Vector2(0.5, 0.5))
		count += leng+0.5
	
func renderImage(path, pos, size):
	var sprite2d = Sprite2D.new()
	sprite2d.texture = load("res://"+path+".svg")
	sprite2d.scale = size
	sprite2d.position = pos
	imageRender.append(sprite2d)
	add_child(sprite2d)

func updateOrder():
	var count = 0
	for ord in orders:
		var leng = len(ord[1])
		count += leng+0.5
	
	
	if randf()*count/9.5 > 0.2:
		return
		
	var distan = 9.5 - count
	var amount = randi_range(1, distan*randf())
	var items = []
	
	for i in amount:
		items.append(Global.iconTypes.pick_random())
		
	orders.append(["Aien", items])
	
	startaudio.play()
