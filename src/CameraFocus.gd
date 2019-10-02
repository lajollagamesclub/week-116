extends Spatial

func _ready():
	$Camera.look_at(Vector3(), Vector3(0, 1, 0))

func _process(delta):
	rotation.y += delta/5.0