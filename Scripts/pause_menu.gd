extends Control


func _ready():
	Global.paused = true


func _process(delta):
	pass


func _on_button_pressed():
	Global.paused = false
	queue_free()


func _on_button_3_pressed():
	get_tree().quit()


func _on_button_2_pressed():
	Global.state = "main"
	Global.paused = false
	queue_free()
