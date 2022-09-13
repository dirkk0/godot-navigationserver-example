extends RigidBody

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	# $NavigationAgent.set_target_location(Vector3(55,10,-2))
	$NavigationAgent.set_target_location(get_node("../target").global_transform.origin)

	var target = $NavigationAgent.get_next_location()
	
	var pos = get_global_transform().origin

	var temp = ""
	temp += str($NavigationAgent.is_navigation_finished()) + "\n"
	temp += str($NavigationAgent.distance_to_target()) + "\n"
	# temp += str($NavigationAgent.get_nav_path()) + "\n" + str(pos)
	temp += str(target) + "\n" + str(pos) 
	get_node("../Label").text =  temp

	var max_vel = 30
	
	# don't overshoot
	if $NavigationAgent.distance_to_target() < 5:
		max_vel = 1

	# Floor normal.
	var n = $RayCast.get_collision_normal()
	if n.length_squared() < 0.01:
		n = Vector3(0, 1, 0)
	var vel = (target - pos).slide(n).normalized() * max_vel
	
	if not $NavigationAgent.is_navigation_finished():
		# this should be:
		# $NavigationAgent.set_velocity(vel)
		# it could also be, if the navmesh ist fixed
		set_linear_velocity(vel)


func _on_NavigationAgent_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity)
