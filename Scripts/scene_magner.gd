extends Node2D
var world
var main
var overr
var credit

var instance

var state = "null"
var prevstate = "null"

# Called when the node enters the scene tree for the first time.
func _ready():
	main = preload("res://Scenes/main_menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not overr:
		overr = preload("res://Scenes/end_game.tscn")
		world = preload("res://world.tscn")
		credit = preload("res://Scenes/credits.tscn")
	state = Global.state
	if state != prevstate:
		if instance:
			instance.queue_free()
		if state == "world":
			instance = world.instantiate()
		if state == "main":
			instance = main.instantiate()
		if state == "overr":
			instance = overr.instantiate()
		if state == "credit":
			instance = credit.instantiate()
		add_child(instance)
		prevstate = state
