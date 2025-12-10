extends Node3D
class_name WeaponController

signal weapon_fired

const BULLET_HOLE = preload("uid://c88yjbgwbdo8o")

@export var bullet: PackedScene
@export var muzzle: Node3D
@export var weapon_stats: WeaponStats
@export var fire_rate_timer: Timer
@export var audio: AudioStreamPlayer3D
@export var hit_audio: AudioStreamPlayer3D
@export var emitter: GPUParticles3D

var bullet_holder: Node3D
var gun_holder: Node3D
var weapon_start_position: Vector3
var weapon_start_rotation: Vector3
var weapon_holder_position: Vector3
var weapon_holder_rotation: Vector3

var ads: bool = false
var ray: RayCast3D
var _camera: Camera3D
var ui: UI
var reloading: bool = false
var max_total_ammo: int

@onready var camera_recoil: Node3D = $"../../.."
@onready var weapon_holder: Node3D = $".."

func _ready() -> void:
	fire_rate_timer.timeout.connect(_auto_fire)
	bullet_holder = get_tree().current_scene.get_node("Bullets")
	gun_holder = get_parent()
	
	weapon_start_position = position
	weapon_start_rotation = rotation
	weapon_holder_position = weapon_holder.position
	weapon_holder_rotation = weapon_holder.rotation
	
	var player: Player = get_tree().get_first_node_in_group("Player")
	_camera = player.get_camera()
	ray = _camera.get_node("RayCast3D")
	ui = get_tree().get_first_node_in_group("UI")
	ui.update_ammo_label(weapon_stats.current_ammo, weapon_stats.total_ammo)
	ui.reload_finshed.connect(_reload_weapon)
	
	max_total_ammo = weapon_stats.total_ammo
	
func _input(event: InputEvent) -> void:
	#Shooting
	if event.is_action_pressed("left_click"):
		if weapon_stats.projectiles:
			fire_projectile()
		else:
			fire_raycast()
		fire_rate_timer.start(weapon_stats.fire_rate)
	if event.is_action_released("left_click"):
		fire_rate_timer.stop()
		
		#ADS
	if event.is_action_pressed("right_click"):
		ads = true
		ui.hide_crosshair(true)
	if event.is_action_released("right_click"):
		ads = false
		ui.hide_crosshair(false)
	
	if event.is_action_pressed("reload") && weapon_stats.total_ammo > 0:
		ui.start_reload_ui(weapon_stats.reload_time)
		reloading = true

func _auto_fire() -> void:
	if weapon_stats.projectiles:
		fire_projectile()
	else:
		fire_raycast()

func _reload_weapon() -> void:
	if weapon_stats.clip_size <= weapon_stats.total_ammo:
		var missing_ammo: int = weapon_stats.clip_size - weapon_stats.current_ammo
		weapon_stats.current_ammo = weapon_stats.clip_size
		weapon_stats.total_ammo -= missing_ammo
	else:
		weapon_stats.current_ammo = weapon_stats.total_ammo
		weapon_stats.total_ammo = 0
	ui.update_ammo_label(weapon_stats.current_ammo, weapon_stats.total_ammo)
	reloading = false

func _physics_process(_delta: float) -> void:
	if !reloading:
		position = lerp(position, weapon_start_position, .1)
		rotation = lerp(rotation, weapon_start_rotation, .1)
	else:
		position = lerp(position, Vector3(weapon_start_position.x, weapon_start_position.y -.25, weapon_start_position.z), .1)
		rotation = lerp(rotation, Vector3(weapon_start_rotation.x, weapon_start_rotation.y, weapon_stats.base_rotation.z - .5), .1)
	
	if ads: 
		weapon_holder.position = lerp(weapon_holder.position, weapon_stats.ads_position, weapon_stats.ads_time)
		weapon_holder.rotation = lerp(weapon_holder.rotation, weapon_stats.ads_rotation, weapon_stats.ads_time)
		_camera.fov = lerp(_camera.fov, 35.0, .1)
	else: 
		weapon_holder.position = lerp(weapon_holder.position, weapon_holder_position, weapon_stats.ads_time)
		weapon_holder.rotation = lerp(weapon_holder.rotation, weapon_holder_rotation, weapon_stats.ads_time)
		_camera.fov = lerp(_camera.fov, 75.0, .1)

func fire_raycast() -> void:
	if weapon_stats.current_ammo > 0 && !reloading:
		shoot_gun()
		weapon_fired.emit()
		
		ray.force_raycast_update()
		if ray.is_colliding():
			var body: Node3D = ray.get_collider()
			if body.is_in_group("Enemy"):
				var health: Node = body.get_node("HealthComponent")
				health.take_damage(weapon_stats.damage)
				_play_hit_sound()
			else: 
				_create_bullet_hole()
		weapon_stats.current_ammo -= 1
		ui.update_ammo_label(weapon_stats.current_ammo, weapon_stats.total_ammo)

func _play_hit_sound() -> void:
	var p = hit_audio.duplicate()
	add_child(p)
	p.play(.8)
	p.connect("finished", p.queue_free)


func fire_projectile() -> void:
	var new_bullet: Area3D = bullet.instantiate()
	new_bullet.position = muzzle.global_transform.origin
	new_bullet.rotation = _camera.global_rotation
	new_bullet.bullet_direction = -_camera.global_transform.basis.z
	new_bullet.set_damage(weapon_stats.damage)
	new_bullet.set_velocity(weapon_stats.bullet_velocity)
	bullet_holder.add_child(new_bullet)
	
	shoot_gun()

func shoot_gun() -> void:
	camera_recoil.recoilFire()
	audio.play()
	
	if ads:
		position = lerp(position, weapon_stats.ads_recoil_position, .1)
	else: 
		position = lerp(position, weapon_stats.recoil_position, .1)
		rotation = lerp(rotation, weapon_stats.recoil_rotation, 1)

func _create_bullet_hole() -> void:
	var bullet_hole: Decal = BULLET_HOLE.instantiate()
	get_tree().current_scene.add_child(bullet_hole)
	bullet_hole.global_position = ray.get_collision_point()
	bullet_hole.look_at(bullet_hole.transform.origin + ray.get_collision_normal(), Vector3.UP)
	bullet_hole.rotate_object_local(Vector3(1, 0, 0), 90)
