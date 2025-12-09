extends CharacterBody3D
class_name Player

@export_category("Movement")
@export var speed: float
@export var walk_speed: float
@export var run_speed: float
@export var gravity: float
@export var jump_impulse: float

@export_category("Mouse")
@export var sensitivity: float

@export_category("FOV Settings")
@export_range(0, 100) var base_fov: float
@export var fov_change: float
@export var _camera: Camera3D

@export_category("View Bobbing")
@export var bob_frequency: float
@export var bob_amplitude: float
var bob: float = 0

@onready var player: CharacterBody3D = $"."
@onready var head: Node3D = $Head

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	speed = walk_speed

func get_camera() -> Camera3D:
	return _camera

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera.rotate_x(-event.relative.y * (sensitivity/25))
		head.rotate_y(-event.relative.x * (sensitivity/25))
		_camera.rotation.x = clamp(_camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 4.0)
	
	#Bobbing
	bob += delta * velocity.length() * float(is_on_floor()) #is_on_floor gives 0 or 1
	_camera.transform.origin = _headbob(bob)
	
	var velocity_clamped = clamp(velocity.length(), .5, run_speed * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	_camera.fov = lerp(_camera.fov, target_fov, delta * 8)
	move_and_slide()

func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplitude
	pos.x = cos(time * bob_frequency / 2) * bob_amplitude
	return pos

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("sprint"):
		speed = run_speed
	if event.is_action_released("sprint"):
		speed = walk_speed
