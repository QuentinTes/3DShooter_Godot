extends Resource
class_name WeaponStats

@export var weapon_name: String

@export var mesh: Mesh

@export_category("Shooting")
@export var damage: int
@export_range(1, 520) var total_ammo: int
@export var current_ammo: int
@export var clip_size: int
@export var reload_time: float
@export var fire_rate: float
@export var raycast_bullet_reach: int

@export_category("Projectiles")
@export var projectiles: bool = false
@export var bullet_velocity: float

@export_category("Weapon Orientation")
@export_subgroup("Start Position")
@export var base_position: Vector3
@export var base_rotation: Vector3
@export_subgroup("ADS Position")
@export var ads_position: Vector3
@export var ads_rotation: Vector3

@export_category("ADS")
@export var ads_time: float

@export_category("Recoil variables")
@export_subgroup("Basic")
@export var recoil_position: Vector3
@export var recoil_rotation: Vector3

@export_subgroup("ADS")
@export var ads_recoil_position: Vector3
