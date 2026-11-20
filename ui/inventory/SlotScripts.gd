class_name SlotView
extends Control
## Hiển thị 1 ô đồ (dùng lại cho Hotbar và Backpack).

# ===== Tín hiệu =====
signal hovered(Item: ItemData)

# ===== Node =====
@onready var Icon: TextureRect = $Icon
@onready var AmountLabel: Label = $AmountLabel

# ===== Trạng thái =====
var Item: ItemData = null


# ===== Vòng đời =====
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)


# ===== Hàm công khai =====
func show_slot(Slot: InventorySlot) -> void:
	Item = Slot.Item
	Icon.texture = Item.Icon if Item != null else null
	AmountLabel.text = str(Slot.Amount)
	AmountLabel.visible = Slot.Amount > 1


# ===== Tín hiệu =====
func _on_mouse_entered() -> void:
	hovered.emit(Item)
