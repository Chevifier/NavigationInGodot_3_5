extends KinematicBody

onready var nav = $NavigationAgent

var next_point = Vector3()
var target = Vector3()
export var speed = 4
#main velocity
var velocity = Vector3()
#adjusted velocity for obsticle avoidance
var new_velocity = Vector3()

func _ready():
	#set the navigation mesh. REQUIRED
	nav.set_navigation(get_node("%Navigation"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector3()
	#check if target is set to something not (0,0,0)
	#hacky not recommended use state machine instead
	if Globals.target_position != Vector3.ZERO:
		#set target from mouse unprojected position
		nav.set_target_location(Globals.target_position)
	else:
		#set target to self if ^^
		nav.set_target_location(global_transform.origin)
	#Get next position in path is remains the same until position in path is reached
	next_point = nav.get_next_location()
	#set the direction to get to the position
	var dir = (next_point-global_transform.origin).normalized()
	#set the initail velocity
	velocity = dir * speed
	#pass the velocity to the nav agent for obsticle avoidance adjustment
	#new velocity returned from velocity_computed signal below
	nav.set_velocity(velocity)

	#Rotation
	var look_dir = global_transform.origin - dir
	look_dir.y = global_transform.origin.y
	if look_dir != global_transform.origin:
		look_at(look_dir,Vector3.UP)
	#apply new adjusted velocity to Kinematic body
	move_and_slide(new_velocity, Vector3.UP)

func _on_NavigationAgent_velocity_computed(safe_velocity):
	new_velocity = safe_velocity
