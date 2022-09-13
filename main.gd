extends Spatial


var path = []

var m = SpatialMaterial.new()

onready var camera = get_node("Camera")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	set_process_input(true)
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white
	
	path = [Vector3(55,0,0), Vector3(10,0,0), Vector3(-2,10,0) ]
	draw_path(path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path = get_node("Bot/NavigationAgent").get_nav_path()
	if path:
		draw_path(path)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		# var target_point = get_closest_point_to_segment(from, to)
		
		var map_rid : RID = get_node("Bot/NavigationAgent").get_navigation_map()
		
		var target_point = NavigationServer.map_get_closest_point_to_segment(map_rid, from, to)
		# print(str(target_point))
		get_node("target").translation = target_point
		# path = get_node("Bot/NavigationAgent").get_nav_path()
		# draw_path(path)

func draw_path(path_array):
	var im = get_node("Draw")
	im.set_material_override(m)
	im.clear()
	im.begin(Mesh.PRIMITIVE_POINTS, null)
	im.add_vertex(path_array[0])
	im.add_vertex(path_array[path_array.size() - 1])
	im.end()
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path_array:
		# print(str(x))
		im.add_vertex(x)
	im.end()

