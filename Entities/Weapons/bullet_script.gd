extends Area3D

var bullet_direction: Vector3 = Vector3.ZERO
var damage: int
var speed: float

@onready var lifetime: Timer = $Lifetime

func _ready() -> void:
	lifetime.timeout.connect(_on_timeout)
	body_entered.connect(_on_body_entered)
	
	lifetime.start(2)

func set_damage(dmg: int) -> void:
	damage = dmg
func set_velocity(vel: float) -> void:
	speed = vel

func _physics_process(delta: float) -> void:
	global_transform.origin += bullet_direction * speed * delta

func _on_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		var health: Node = body.get_node("HealthComponent")
		health.take_damage(damage)
		#health.get_health()
	queue_free()
