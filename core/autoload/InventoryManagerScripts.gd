extends Node
## Quản lý túi đồ (autoload "InventoryManager").
## Dữ liệu vật phẩm nằm ở res://data/items/*.tres (ItemData).

# ===== Tín hiệu =====
signal inventory_changed
signal item_added(Item: ItemData)

# ===== Hằng số =====
const SlotCount: int = 12
const ItemFolder: String = "res://data/items/"

# ===== Dữ liệu =====
var Slots: Array[InventorySlot] = []
var Database: Dictionary[String, ItemData] = {}


# ===== Vòng đời =====
func _ready() -> void:
	for Index in SlotCount:
		Slots.append(InventorySlot.new())
	_load_database()


# ===== Hàm công khai =====
func add_item(ItemId: String, Amount: int = 1) -> bool:
	var Item: ItemData = Database.get(ItemId)
	if Item == null:
		push_warning("Không có vật phẩm '%s' trong %s" % [ItemId, ItemFolder])
		return false

	var Remaining: int = Amount

	# 1) Dồn vào ô đang chứa cùng vật phẩm còn chỗ
	for Slot in Slots:
		if Remaining == 0:
			break
		if Slot.Item == Item and Slot.Amount < Item.MaxStack:
			var Moved: int = mini(Item.MaxStack - Slot.Amount, Remaining)
			Slot.Amount += Moved
			Remaining -= Moved

	# 2) Phần còn lại đặt vào ô trống
	for Slot in Slots:
		if Remaining == 0:
			break
		if Slot.is_empty():
			var Moved: int = mini(Item.MaxStack, Remaining)
			Slot.Item = Item
			Slot.Amount = Moved
			Remaining -= Moved

	if Remaining == Amount:
		return false # túi đầy, không thêm được gì

	inventory_changed.emit()
	item_added.emit(Item)
	return Remaining == 0


func remove_item(ItemId: String, Amount: int = 1) -> bool:
	if get_amount(ItemId) < Amount:
		return false

	var Remaining: int = Amount
	for Slot in Slots:
		if Remaining == 0:
			break
		if not Slot.is_empty() and Slot.Item.Id == ItemId:
			var Taken: int = mini(Slot.Amount, Remaining)
			Slot.Amount -= Taken
			Remaining -= Taken
			if Slot.Amount == 0:
				Slot.Item = null

	inventory_changed.emit()
	return true


func has_item(ItemId: String) -> bool:
	return get_amount(ItemId) > 0


func get_amount(ItemId: String) -> int:
	var Total: int = 0
	for Slot in Slots:
		if not Slot.is_empty() and Slot.Item.Id == ItemId:
			Total += Slot.Amount
	return Total


# ===== Hàm nội bộ =====
func _load_database() -> void:
	for FileName in DirAccess.get_files_at(ItemFolder):
		# Khi export, file .tres đổi thành .tres.remap nên phải cắt hậu tố
		var CleanName: String = FileName.trim_suffix(".remap")
		if not CleanName.ends_with(".tres"):
			continue
		var Item := load(ItemFolder + CleanName) as ItemData
		if Item != null and Item.Id != "":
			Database[Item.Id] = Item
