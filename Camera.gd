extends Camera


var velocity = Vector3()
var speed = 10
onready var camera_swivel = get_parent()
var mouse = Vector2()
var mouse_rel = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	velocity = Vector3()
	var vec = Input.get_vector("left","right","down", "up")
	
	velocity += camera_swivel.global_transform.basis.x *vec.x * speed
	velocity -= camera_swivel.global_transform.basis.z *vec.y * speed
	
	camera_swivel.global_translate(velocity * delta)
	
	if Input.is_action_pressed("right_mouse"):
		camera_swivel.rotation_degrees.y -= mouse_rel.x * 25 * delta
		rotation_degrees.x -= mouse_rel.y * 25 * delta
		rotation_degrees.x = clamp(rotation_degrees.x,-90,90)
		mouse_rel = Vector2()
	if Input.is_action_just_pressed("left_mouse"):
		Globals.target_position = get_mouse_world_point()
		

func get_mouse_world_point():
	var pos = Vector3()
	var space = get_world().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_ray_normal(mouse) * 10000
	var data = space.intersect_ray(start,end)
	if data.empty():
		pass
	else:
		pos = data.position
	return pos


func _input(event):
	if event is InputEventMouseMotion:
		mouse = event.position;
		mouse_rel = event.relative
