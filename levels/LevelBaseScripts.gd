class_name LevelBase
extends Node2D
## Lớp cha của mọi màn chơi 2D. Màn con CHỈ ghi đè _setup_level() (đừng ghi đè _ready).
## Quy ước: mỗi màn có node con tên "Player" (PlayerScene).

# ===== Cấu hình (chỉnh trong Inspector của màn) =====
@export var CameraLimits: Rect2i = Rect2i(0, 0, 2624, 770)
@export var PlayerMode: PlayerCharacter.MovementMode = PlayerCharacter.MovementMode.SIDE

# ===== Node =====
@onready var Player: PlayerCharacter = $Player


# ===== Vòng đời =====
func _ready() -> void:
	Player.set_mode(PlayerMode)
	_apply_camera_limits()
	_setup_level()


## Màn con ghi đè hàm này để khởi tạo riêng.
func _setup_level() -> void:
	pass


# ===== Hàm tiện ích dùng chung =====
func play_looping(Sound: AudioStreamPlayer) -> void:
	Sound.play()
	Sound.finished.connect(Sound.play)


func _apply_camera_limits() -> void:
	var Cam: Camera2D = Player.Camera
	Cam.limit_left = CameraLimits.position.x
	Cam.limit_top = CameraLimits.position.y
	Cam.limit_right = CameraLimits.end.x
	Cam.limit_bottom = CameraLimits.end.y
