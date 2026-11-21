extends LevelBase
## Màn trong biệt thự (kiểu di chuyển và giới hạn camera chỉnh ở Inspector).

# ===== Hằng số =====
const NewsNote: String = "[ TIN KHẨN: VỤ MẤT TÍCH BÍ ẨN ]\n\nToàn bộ người dân ở vùng ngoại ô đang sống trong sợ hãi.\nMột thực thể biến dạng đã bắt cóc từng người trong đêm.\nCảnh sát bất lực trước dấu vết để lại trong cánh rừng..."

# ===== Node =====
@onready var DoorArea: Interactable = $Door/DoorArea
@onready var TableArea: Interactable = $Table/TableArea
@onready var BoxArea: Interactable = $Box/BoxArea
@onready var Switch: AudioStreamPlayer2D = $Switch
@onready var Handle: AudioStreamPlayer2D = $Door/Handle
@onready var Rain: AudioStreamPlayer = $Rain
@onready var BackgroundSound: AudioStreamPlayer = $BgSound


# ===== Khởi tạo =====
func _setup_level() -> void:
	play_looping(Rain)
	play_looping(BackgroundSound)

	DoorArea.interacted.connect(_on_door_interacted)
	TableArea.interacted.connect(_on_table_interacted)
	BoxArea.interacted.connect(_on_box_interacted)


# ===== Tương tác =====
func _on_door_interacted() -> void:
	if InventoryManager.has_item("flashlight") and InventoryManager.has_item("key"):
		InventoryManager.remove_item("key")
		Switch.play()
		Player.Camera.position_smoothing_enabled = false
		Transition.change_scene(ScenePaths.OutSide)
	else:
		Handle.play()
		EventBus.show_log("Cửa bị khóa...")


func _on_box_interacted() -> void:
	Switch.play()
	if InventoryManager.has_item("flashlight") and InventoryManager.has_item("key"):
		EventBus.show_log("Thùng rỗng")
	else:
		InventoryManager.add_item("flashlight")
		InventoryManager.add_item("key")
		InventoryManager.add_item("vanqy")
		EventBus.show_log("Đã tìm thấy đèn pin và chìa khóa!")


func _on_table_interacted() -> void:
	Switch.play()
	EventBus.show_note(NewsNote)
