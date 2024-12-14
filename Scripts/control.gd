extends Control

var rentSlider
var rentValue
var orderCount
var shopManager

var pauseMenu
var instance

func _ready():
	rentSlider = get_node("ProgressBar2")
	rentValue = get_node("RichTextLabel2")
	orderCount = get_node("RichTextLabel3")
	shopManager = get_node("../../Manager")
	
	pauseMenu = preload("res://Scenes/pause_menu.tscn")


func _process(delta):
	if Global.paused:
		return
	rentSlider.value = shopManager.timer
	rentValue.text = shopManager.switchState
	var orderText = Global.orders
	if orderText < 0:
		orderText = 0
	orderCount.text = str(orderText)
	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Global.paused:
			Global.paused = false
			instance.queue_free()
		else:
			instance = pauseMenu.instantiate()
			add_child(instance)
