class_name TriggerArea
extends Area2D
## Vùng kích hoạt tự động khi người chơi bước vào (jumpscare, gợi ý, cutscene...).

# ===== Tín hiệu =====
signal triggered(Body: Node2D)

# ===== Cấu hình =====
@export var IsOneShot: bool = true

# ===== Trạng thái =====
var HasTriggered: bool = false


# ===== Vòng đời =====
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# ===== Tín hiệu Area2D =====
func _on_body_entered(Body: Node2D) -> void:
	if not Body.is_in_group("player"):
		return
	if IsOneShot and HasTriggered:
		return
	HasTriggered = true
	triggered.emit(Body)
