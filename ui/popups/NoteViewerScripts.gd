extends CanvasLayer
## Cửa sổ đọc giấy/ghi chú. Mở bằng EventBus.show_note(Text), đóng bằng E hoặc Esc.

# ===== Node =====
@onready var NoteLabel: Label = $Panel/NoteLabel

# ===== Trạng thái =====
var IsOpen: bool = false


# ===== Vòng đời =====
func _ready() -> void:
	visible = false
	EventBus.note_requested.connect(open)


func _exit_tree() -> void:
	if IsOpen:
		GameState.unlock_input() # tránh kẹt khóa input khi đổi màn lúc đang đọc


func _unhandled_input(event: InputEvent) -> void:
	if not IsOpen:
		return
	if event.is_action_pressed("access") or event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()


# ===== Hàm công khai =====
func open(Text: String) -> void:
	if IsOpen:
		return
	NoteLabel.text = Text
	IsOpen = true
	visible = true
	GameState.lock_input()


func close() -> void:
	if not IsOpen:
		return
	IsOpen = false
	visible = false
	GameState.unlock_input()
