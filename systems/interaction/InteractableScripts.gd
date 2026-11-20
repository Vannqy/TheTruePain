class_name Interactable
extends Area2D
## Vùng tương tác: người chơi đứng trong vùng và nhấn "access" (E) -> phát tín hiệu interacted.
## Gắn script này vào Area2D, rồi nối tín hiệu interacted ở script của màn chơi.

# ===== Tín hiệu =====
signal interacted

# ===== Cấu hình (chỉnh trong Inspector) =====
@export var Prompt: String = ""
@export var IsEnabled: bool = true

# ===== Trạng thái =====
var IsPlayerInside: bool = false


# ===== Vòng đời =====
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
	if not IsPlayerInside or not IsEnabled:
		return
	if GameState.is_input_locked():
		return
	if event.is_action_pressed("access"):
		interacted.emit()
		get_viewport().set_input_as_handled()


# ===== Tín hiệu Area2D =====
func _on_body_entered(Body: Node2D) -> void:
	if not Body.is_in_group("player"):
		return
	IsPlayerInside = true
	if Prompt != "":
		EventBus.show_log(Prompt)


func _on_body_exited(Body: Node2D) -> void:
	if Body.is_in_group("player"):
		IsPlayerInside = false
