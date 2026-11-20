class_name ItemData
extends Resource
## Mô tả 1 loại vật phẩm. Tạo vật phẩm mới = tạo file .tres trong res://data/items/

@export var Id: String = ""
@export var DisplayName: String = ""
@export_multiline var Description: String = ""
@export var Icon: Texture2D
@export var MaxStack: int = 1
