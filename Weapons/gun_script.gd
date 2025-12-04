extends Node3D

@export var bullet: PackedScene
@export var muzzle: Node3D
@export var _camera: Camera3D

var holder: Node3D
var gun_holder: Node3D
var gun_position: Vector3
var gun_rotation: Vector3

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	holder = get_tree().current_scene.get_node("Bullets")
	gun_holder = get_parent()
	gun_position = position
	gun_rotation = rotation
	_camera = get_tree().get_first_node_in_group("Player").get_node("Head").get_node("Camera3D")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var new_bullet: Area3D = bullet.instantiate()
		new_bullet.position = muzzle.global_transform.origin
		new_bullet.rotation = _camera.global_rotation
		new_bullet.bullet_direction = -_camera.global_transform.basis.z
		holder.add_child(new_bullet)
		
		audio_stream_player_3d.play()
		
		position = lerp(position, Vector3(gun_position.x, gun_position.y+.5, gun_position.z + 1), .1)
		rotation = lerp(rotation, Vector3(gun_rotation.x + 2, gun_rotation.y, gun_rotation.z), .1)

func _physics_process(_delta: float) -> void:
	position = lerp(position, gun_position, .1)
	rotation = lerp(rotation, gun_rotation, .1)
