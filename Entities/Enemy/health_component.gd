extends Node

@export var max_health: int

var current_health: int

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	animation_player.play("hit")
	if (current_health - amount) <= 0:
		die()
	else:
		current_health -= amount

func die() -> void:
	get_parent().queue_free()

func get_health() -> void:
	print(str(current_health) + "/" + str(max_health))
