extends Control

func _ready():
	pass

func _process(delta):
	pass


func _on_button_pressed():
	Global.state = "world"


func _on_button_3_pressed():
	get_tree().quit()


func _on_button_2_pressed():
	Global.state = "credit"
