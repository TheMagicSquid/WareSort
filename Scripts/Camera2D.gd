extends Camera2D

var mousemovesize = Vector2(100, 100)
var movespeed = 900
var cameraposition = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.paused:
		return
	#print(get_viewport().get_mouse_position())
	if get_viewport().get_mouse_position().x > get_viewport().size.x - mousemovesize.x:
		cameraposition.x += movespeed*delta*abs(get_viewport().get_mouse_position().x-get_viewport().size.x + mousemovesize.x)/mousemovesize.x
	if get_viewport().get_mouse_position().x < mousemovesize.x:
		cameraposition.x -= movespeed*delta*abs(get_viewport().get_mouse_position().x-mousemovesize.x)/mousemovesize.x
	if get_viewport().get_mouse_position().y > get_viewport().size.y - mousemovesize.y:
		cameraposition.y += movespeed*delta*abs(get_viewport().get_mouse_position().y-get_viewport().size.y + mousemovesize.y)/mousemovesize.y
	if get_viewport().get_mouse_position().y < mousemovesize.y:
		cameraposition.y -= movespeed*delta*abs(get_viewport().get_mouse_position().y-mousemovesize.y)/mousemovesize.y
	
	cameraposition = cameraposition.clamp(Vector2(-1000,-1200), Vector2(1500,1000))
	
	position = lerp(position, cameraposition, 0.1)
