extends Node2D

var dragged = false
var touchingmouse = false
var mousedown = false
var touching = false

var target = Vector2(0, 0)

var bodies = []

var type

var camera
var collide
var statics
var sprite

var sound1
var sound3
var sound4
var hit1
var hit2

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("../../Camera2D")
	collide = get_node("BodyCollider")
	statics = get_node("StaticBody2D")
	sprite = get_node("Icon")
	
	sound1 = get_node("Sound1")
	sound3 = get_node("Sound3")
	sound4 = get_node("Sound4")
	hit1 = get_node("Hit1")
	hit2 = get_node("Hit2")
	target = global_position
	
	if len(Global.iconQueue) == 0:
		type = Global.allIconTypes.pick_random()
	else:
		type = Global.iconQueue[0]
		Global.iconQueue.pop_front()

	sprite.texture = load("res://Icons/"+type+".svg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.paused:
		return
	if not dragged and (touchingmouse and mousedown) and Global.draggingid == null:
		Global.draggingid = self
		dragged = true
		
	if dragged and (not mousedown):
		Global.draggingid = null
		dragged = false
		position = round(position/64)*64
		var random = randi_range(1,3)
		var chosenSound = sound1
		match random:
			1:
				chosenSound = sound1
			2:
				chosenSound = sound3
			3:
				chosenSound = sound4
		chosenSound.volume_db = randi_range(-10,0)
		chosenSound.pitch_scale = randf_range(0.5,1.5)
		chosenSound.play()
	
	if dragged:
		if touching:
			#print("ehll")
			position = round(position/64)*64
		else:
			position = target
		
		target = (get_viewport().get_mouse_position()-Vector2(get_viewport().size/2))/camera.zoom+camera.position
		collide.position = target - position


func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		mousedown = event.pressed


func _on_area_2d_mouse_exited():
	touchingmouse = false

func _on_area_2d_mouse_entered():
	touchingmouse = true

func _on_body_collider_body_exited(body):
	if body != statics and body in bodies:
		bodies.erase(body)
		if len(bodies) == 0:
			touching = false

func _on_body_collider_body_entered(body):
	if body != statics and body not in bodies:
		bodies.append(body)
		touching = true
		if len(bodies) > 1:
			return
		var random = randi_range(1,2)
		var chosenSound = hit1
		match random:
			1:
				chosenSound = hit1
			2:
				chosenSound = hit2
		chosenSound.volume_db = randi_range(-10,0)
		chosenSound.pitch_scale = randf_range(0.5,1.5)
		chosenSound.play()
