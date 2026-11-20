class_name InventorySlot
extends RefCounted
## 1 ô trong túi: chứa vật phẩm + số lượng.

var Item: ItemData = null
var Amount: int = 0


func is_empty() -> bool:
	return Item == null
