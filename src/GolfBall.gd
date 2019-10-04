extends KinematicBody

var accel = Vector3(0, -9.8, 0)
var velocity = Vector3()

func _physics_process(delta):
	velocity += accel*delta
	if $RayCast.is_colliding():
		velocity.y = 0.0
	move_and_slide(velocity)