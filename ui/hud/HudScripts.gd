extends CanvasLayer
## HUD luôn hiện khi chơi: dòng thông báo + thanh slot nhanh (Hotbar) + balo.

# ===== Hằng số =====
const SlotScene: PackedScene = preload("res://ui/inventory/SlotScene.tscn")
const HotbarSize: int = 4
const LogDuration: float = 3.0

# ===== Node =====
@onready var ActionLog: Label = $ActionLog
@onready var Hotbar: HBoxContainer = $Hotbar
@onready var Backpack: BackpackPanel = $Backpack
@onready var LogTimer: Timer = $LogTimer

# ===== Trạng thái =====
var HotbarSlots: Array[SlotView] = []


# ===== Vòng đời =====
func _ready() -> void:
	ActionLog.visible = false
	LogTimer.one_shot = true
	LogTimer.timeout.connect(_on_log_timer_timeout)

	for Index in HotbarSize:
		var View := SlotScene.instantiate() as SlotView
		Hotbar.add_child(View)
		HotbarSlots.append(View)

	EventBus.log_requested.connect(show_log)
	InventoryManager.inventory_changed.connect(_refresh_hotbar)
	_refresh_hotbar()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		Backpack.toggle()
		get_viewport().set_input_as_handled()
	elif Backpack.visible and event.is_action_pressed("ui_cancel"):
		Backpack.close()
		get_viewport().set_input_as_handled()


# ===== Hàm công khai =====
func show_log(Message: String) -> void:
	ActionLog.text = Message
	ActionLog.visible = true
	LogTimer.start(LogDuration)


# ===== Hàm nội bộ =====
func _refresh_hotbar() -> void:
	for Index in HotbarSlots.size():
		HotbarSlots[Index].show_slot(InventoryManager.Slots[Index])


# ===== Tín hiệu =====
func _on_log_timer_timeout() -> void:
	ActionLog.visible = false
