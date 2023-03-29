extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 6
const MOUSE_SENSITIVITY = 0.1
@onready var playerHead = $Head
@onready var camera = $Head/Camera3D
var gravity = 17

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		playerHead.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		playerHead.rotation.x = clamp(playerHead.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
