extends Control
class_name UI

signal reload_finshed

@onready var crosshair: TextureRect = $Crosshair
@onready var ammo_label: RichTextLabel = $AmmoLabel
@onready var reload_progress: TextureProgressBar = $ReloadProgress

var reloading: bool = false
var reload_duration: float
var reload_timer: float

func _ready() -> void:
	pass

func hide_crosshair(_hide: bool) -> void:
	if _hide:
		crosshair.visible = false
	else:
		crosshair.visible = true

func update_ammo_label(current_ammo: int, max_ammo: int) -> void:
	ammo_label.text = ("Ammo: " + str(current_ammo) + "/" + str(max_ammo))

func start_reload_ui(time: float) -> void:
	reload_duration = time
	reload_timer = 0.0
	reload_progress.value = 0.0
	reloading = true
	reload_progress.visible = true

func _process(_delta: float) -> void:
	if reloading:
		reload_progress.value +=  reload_duration

func _on_reload_progress_value_changed(value: float) -> void:
	if value == reload_progress.max_value:
		reload_finshed.emit()
		reload_progress.visible = false
		reloading = false
