extends CharacterBody3D

@export var speed: float
@export var climb_speed: float = 5

var enemy_pos: Vector3
var player_pos: Vector3
var player: Player

@onready var ray: RayCast3D = $RayCast3D
@onready var ray_cast_3d_2: RayCast3D = $RayCast3D2
@onready var ray_cast_3d_3: RayCast3D = $RayCast3D3

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player == null: 
		return
	
	enemy_pos = global_transform.origin
	player_pos = player.global_transform.origin
	
	var dir = (player_pos - enemy_pos)
	dir.y = 0
	dir = dir.normalized()
	
	velocity = dir * speed * delta
	
	if !is_on_floor():
		velocity.y -= 9.81
	
	look_at(enemy_pos + dir, Vector3.UP)
	
	ray.force_raycast_update()
	ray_cast_3d_2.force_raycast_update()
	ray_cast_3d_3.force_raycast_update()
	
	if ray.is_colliding():
		var body: Node3D = ray.get_collider()
		if body.is_in_group("Enemy"):
			velocity.y = climb_speed
	if ray_cast_3d_2.is_colliding():
		var body: Node3D = ray_cast_3d_2.get_collider()
		if body.is_in_group("Enemy"):
			velocity.y = climb_speed
	if ray_cast_3d_3.is_colliding():
		var body: Node3D = ray_cast_3d_3.get_collider()
		if body.is_in_group("Enemy"):
			velocity.y = climb_speed
	
	move_and_slide()
