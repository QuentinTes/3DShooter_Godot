extends CharacterBody3D

@export var speed: float

var enemy_pos: Vector3
var player_pos: Vector3
var player: Player

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
	
	move_and_slide()
