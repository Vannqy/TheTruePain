class_name BackpackPanel
extends Control
## Bảng balo đầy đủ (mở/đóng bằng phím toggle_inventory). Mở balo sẽ khóa input của người chơi.

# ===== Hằng số =====
const SlotScene: PackedScene = preload("res://ui/inventory/SlotScene.tscn")

# ===== Node =====
@onready var Grid: GridContainer = $Panel/Grid
@onready var ItemName: Label = $Panel/ItemName
@onready var ItemDescription: Label = $Panel/ItemDescription

# ===== Trạng thái =====
var SlotViews: Array[SlotView] = []


# ===== Vòng đời =====
func _ready() -> void:
	visible = false
	for Index in InventoryManager.SlotCount:
		var View := SlotScene.instantiate() as SlotView
		Grid.add_child(View)
		View.hovered.connect(_on_slot_hovered)
		SlotViews.append(View)

	InventoryManager.inventory_changed.connect(_refresh)
	_refresh()
	_show_item(null)


func _exit_tree() -> void:
	if visible:
		GameState.unlock_input() # tránh kẹt khóa input khi đổi màn lúc đang mở balo


# ===== Hàm công khai =====
func toggle() -> void:
	if visible:
		close()
	else:
		open()


func open() -> void:
	if GameState.is_input_locked():
		return
	visible = true
	GameState.lock_input()
	_refresh()


func close() -> void:
	if not visible:
		return
	visible = false
	GameState.unlock_input()


# ===== Hàm nội bộ =====
func _refresh() -> void:
	for Index in SlotViews.size():
		SlotViews[Index].show_slot(InventoryManager.Slots[Index])


func _show_item(Item: ItemData) -> void:
	ItemName.text = Item.DisplayName if Item != null else ""
	ItemDescription.text = Item.Description if Item != null else ""


# ===== Tín hiệu =====
func _on_slot_hovered(Item: ItemData) -> void:
	_show_item(Item)
