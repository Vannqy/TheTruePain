extends Node
## Trạng thái chung của game (autoload "GameState"): khóa input, cờ cốt truyện.

# ===== Tín hiệu =====
signal input_lock_changed(IsLocked: bool)

# ===== Trạng thái =====
var InputLockCount: int = 0
var Flags: Dictionary[String, bool] = {}


# ===== Khóa input (đếm số lần khóa, nhiều hệ thống khóa chồng nhau vẫn đúng) =====
func lock_input() -> void:
	InputLockCount += 1
	if InputLockCount == 1:
		input_lock_changed.emit(true)


func unlock_input() -> void:
	if InputLockCount == 0:
		return
	InputLockCount -= 1
	if InputLockCount == 0:
		input_lock_changed.emit(false)


func is_input_locked() -> bool:
	return InputLockCount > 0


# ===== Cờ cốt truyện =====
func set_flag(FlagName: String, Value: bool = true) -> void:
	Flags[FlagName] = Value


func has_flag(FlagName: String) -> bool:
	return Flags.get(FlagName, false)
