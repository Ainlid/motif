extends Spatial

var camera

func _ready():
	camera = get_viewport().get_camera()

func _process(delta):
	var global_pos = global_transform.origin
	var camera_pos = camera.global_transform.origin
	camera_pos = Vector3(camera_pos.x, global_pos.y, camera_pos.z)
	look_at(camera_pos, Vector3.UP)
