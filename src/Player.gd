extends KinematicBody

var SPEED = 6
const ACCELERATION = 3
const SLOW_ACCELERATION = 0.2
const DE_ACCELERATION = 5

export var gravity = -9.8

onready var camera: Camera = $Camera

var velocity = Vector3()
var on_default: bool = true


func _physics_process(delta):
	var cur_camera_transform = camera.get_global_transform()

	var dir = Vector3()
	var turn_dir: int = 0
	
	if(Input.is_action_pressed("g_forward")):
		dir += -cur_camera_transform.basis[2]
	if(Input.is_action_pressed("g_backward")):
		dir += cur_camera_transform.basis[2]
	if(Input.is_action_pressed("g_left")):
		dir += -cur_camera_transform.basis[0]
	if(Input.is_action_pressed("g_right")):
		dir += cur_camera_transform.basis[0]
	if(Input.is_action_pressed("g_turn_right")):
		turn_dir -= 1
	if(Input.is_action_pressed("g_turn_left")):
		turn_dir += 1
	
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	if Input.is_action_just_pressed("g_jump") and $RayCast.is_colliding():
		velocity.y = 3

	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION
	
	if Input.is_action_just_pressed("g_right"):
		on_default = false
		$AnimatedSprite3D.play("right")
	elif Input.is_action_just_pressed("g_left"):
		on_default = false
		$AnimatedSprite3D.play("left")
	elif Input.is_action_just_pressed("g_forward"):
		on_default = false
		$AnimatedSprite3D.play("backward")
	elif Input.is_action_just_pressed("g_backward"):
		on_default = false
		$AnimatedSprite3D.play("forward")
	
	if (dir.dot(hv) > 0):
		
		accel = ACCELERATION
		if $RayCast.is_colliding():
			if $RayCast.get_collider().is_in_group("floor"):
				accel = SLOW_ACCELERATION
	
	if not on_default and dir.length_squared() == 0.0:
		$AnimatedSprite3D.play($AnimatedSprite3D.animation + "-default")
		on_default = true
	
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	rotate_y(5*turn_dir*delta)
	
	$Camera.look_at(global_transform.origin, Vector3(0, 1, 0))