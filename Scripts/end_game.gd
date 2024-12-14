extends Control

var result
var audio

func _ready():
	result = get_node("RichTextLabel2")
	audio = get_node("AudioStreamPlayer2D")
	result.text = "You managed "+str(Global.orders-1)+" orders"
	audio.play()

func _process(delta):
	pass

func _on_button_pressed():
	Global.state = "world"

func _on_button_2_pressed():
	Global.state = "main"

func _on_button_3_pressed():
	get_tree().quit()
