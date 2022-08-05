extends KinematicBody


onready var nav_obs = $NavigationObstacle
# Called when the node enters the scene tree for the first time.
func _ready():
	#pass navigation to NavigationObstacle. REQUIRED
	nav_obs.set_navigation(get_node("%Navigation"))
