extends Control

# ===== Node =====
@onready var StoryLabel: Label = $StoryLabel
@onready var IntroMusic: AudioStreamPlayer = $IntroMusic
@onready var FadeRect: ColorRect = $FadeRect

# ===== Dữ liệu =====
var StoryLines: Array[String] = [
	"Một người mẹ không con...",
	"Đêm lạnh lẽo, tiếng thở dài hòa cùng ngọn lửa bập bùng thiêu rụi tất cả.",
	"Sự cô độc và căm phẫn xé toạc màn đêm...",
	"Và giọt nước mắt bất lực rơi xuống tro tàn vì đứa con gái đã chết thê thảm.",
	"Nhiều năm sau...",
	"Một bức thư bí ẩn được đặt trên bàn làm việc, mở đầu cho bi kịch."
]

# ===== Trạng thái =====
var CurrentLineIndex: int = 0
var IsTransitioning: bool = false


# ===== Vòng đời =====
func _ready() -> void:
	IntroMusic.play()
	IntroMusic.finished.connect(IntroMusic.play)

	FadeRect.modulate.a = 1.0
	var FadeTween := create_tween()
	FadeTween.tween_property(FadeRect, "modulate:a", 0.0, 1.5)

	show_next_line()


func _input(event: InputEvent) -> void:
	if IsTransitioning:
		return

	var IsAccept: bool = event.is_action_pressed("ui_accept")
	var IsLeftClick: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	if not (IsAccept or IsLeftClick):
		return

	CurrentLineIndex += 1
	if CurrentLineIndex < StoryLines.size():
		show_next_line()
	else:
		end_intro()


# ===== Hàm xử lý =====
func show_next_line() -> void:
	StoryLabel.text = StoryLines[CurrentLineIndex]
	StoryLabel.modulate.a = 0.0
	var TextTween := create_tween()
	TextTween.tween_property(StoryLabel, "modulate:a", 1.0, 1.0)


func end_intro() -> void:
	IsTransitioning = true
	Transition.change_scene(ScenePaths.House)
