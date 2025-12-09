extends Node3D

const MP_5 = preload("uid://c3u81lsx03lht")

@export var weapon_holder: Node3D

var ui: UI
var current_weapon: WeaponController

func _ready() -> void:
	ui = get_tree().get_first_node_in_group("UI")
	load_weapon(MP_5)

func load_weapon(weapon: PackedScene) -> void:
	current_weapon = weapon.instantiate()
	weapon_holder.add_child(current_weapon)

func add_ammo(amount: int) -> void:
	current_weapon = weapon_holder.get_child(0)
	if current_weapon.weapon_stats.total_ammo + amount <= current_weapon.max_total_ammo:
		current_weapon.weapon_stats.total_ammo += amount
	else:
		current_weapon.weapon_stats.total_ammo = current_weapon.max_total_ammo
	ui.update_ammo_label(current_weapon.weapon_stats.current_ammo, current_weapon.weapon_stats.total_ammo)
