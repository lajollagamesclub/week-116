extends KinematicBody

var accel = Vector3(0, -9.8, 0)
var velocity: Vector3 = Vector3()

func _input(event):
	if event.is_action("g_jump"):
		velocity = Vector3(4, 0, 4)

func _physics_process(delta):
	velocity += accel*delta
	velocity += get_friction_accel(delta)*delta
	if $RayCast.is_colliding():
		velocity.y = 0.0
#	velocity = lerp(velocity, Vector3(), 5.0*delta)
	
	move_and_slide(velocity)
	# reflect
	for c in get_slide_count():
		var cur_collision = get_slide_collision(c)
		if cur_collision.collider.is_in_group("bounds"):
			velocity = cur_collision.normal
			break

func get_friction_accel(delta) -> Vector3:
	if velocity.length_squared() <= 0.1:
		return -velocity/delta
	else:
		var flat_velocity = Vector3(velocity.x, 0, velocity.z)
		return -flat_velocity.normalized()*3.0