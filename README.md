# The True Pain (Godot 4.7)

## Cây thư mục
```
assets/    chỉ chứa file thô (audio/, sprites/) - KHÔNG đặt script/scene ở đây
core/      autoload + hạ tầng: EventBus, GameState, InventoryManager, Transition, ScenePaths
data/      dữ liệu .tres (items/ ...) - thêm vật phẩm = thêm 1 file
entities/  nhân vật & quái (player/, sau này enemy/)
levels/    mỗi màn 1 thư mục (intro/ house/ outside/) + LevelBaseScripts.gd
systems/   hệ thống dùng lại: inventory/, interaction/
ui/        hud/ (HUD), inventory/ (Slot, Backpack), popups/ (đọc ghi chú)
```

## Quy ước
- Biến/Node: PascalCase. Scene: XxxScene.tscn. Script: XxxScripts.gd. Hàm: snake_case.
- Đường dẫn scene chỉ ghi trong `core/ScenePathsScripts.gd`.
- Màn chơi kế thừa `LevelBase`, chỉ ghi đè `_setup_level()`.
- Các hệ thống giao tiếp qua signal / `EventBus`, không gọi chéo node của nhau.

## Việc hay làm
- Thêm vật phẩm: tạo `data/items/XxxItem.tres` (kiểu ItemData), `InventoryManager.add_item("id")`.
- Thêm vật thể tương tác: gắn `InteractableScripts.gd` vào Area2D, đặt `Prompt`, nối signal `interacted`.
- Thêm jumpscare/gợi ý: gắn `TriggerAreaScripts.gd`, nối signal `triggered`.
- Đổi kiểu di chuyển của màn: Inspector của node gốc -> `Player Mode` (SIDE / TOP_DOWN).
- Phím: WASD di chuyển, E tương tác, F đèn pin, Tab balo.
