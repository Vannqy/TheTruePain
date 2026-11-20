extends LevelBase
## Màn bên ngoài biệt thự.

# ===== Node =====
@onready var BackgroundMusic: AudioStreamPlayer = $BgMusic
@onready var ScreamSound: AudioStreamPlayer = $ScreamSound
@onready var ScreamArea: TriggerArea = $ScreamPoint/ScreamArea


# ===== Khởi tạo =====
func _setup_level() -> void:
	# TẠM THỜI để test: cấp đèn pin khi vào màn này
	if not InventoryManager.has_item("flashlight"):
		InventoryManager.add_item("flashlight")

	play_looping(BackgroundMusic)
	ScreamArea.triggered.connect(_on_scream_triggered)


# ===== Tín hiệu =====
func _on_scream_triggered(_Body: Node2D) -> void:
	ScreamSound.play()
