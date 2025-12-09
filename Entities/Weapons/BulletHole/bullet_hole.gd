extends Decal

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	var fade = get_tree().create_tween()
	fade.tween_property(self, "modulate", Color.TRANSPARENT, 1)
