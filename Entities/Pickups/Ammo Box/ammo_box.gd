extends Node3D

@export var pickup_area: Area3D

func _ready() -> void:
	pickup_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var weapon_manager: Node3D = body.get_node("WeaponManager")
		weapon_manager.add_ammo(20)
		print("Pick")
