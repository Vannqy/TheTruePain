extends Node
## Kênh tín hiệu toàn cục (autoload "EventBus").
## Các hệ thống nói chuyện qua đây thay vì gọi trực tiếp lẫn nhau.

# ===== Tín hiệu =====
signal log_requested(Message: String)
signal note_requested(Text: String)


# ===== Hàm công khai =====
func show_log(Message: String) -> void:
	log_requested.emit(Message)


func show_note(Text: String) -> void:
	note_requested.emit(Text)
