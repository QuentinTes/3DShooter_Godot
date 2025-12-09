extends Node3D

const ENEMY = preload("uid://c8env8p0ublui")

var rng = RandomNumberGenerator.new()
var spawners: Array[Node3D]

@onready var timer: Timer = $Timer
@onready var enemies: Node3D = $"../Enemies"

func _ready() -> void:
	timer.timeout.connect(_timeout)
	for i in get_child_count():
		if get_child(i) is Node3D:
			spawners.append(get_child(i))

func _timeout() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	var random = rng.randi_range(1,4)
	var temp_enemy: CharacterBody3D = ENEMY.instantiate()
	temp_enemy.position = spawners.get(random -1).global_transform.origin
	enemies.add_child(temp_enemy)
