extends CanvasLayer

# ===== Node =====
@onready var FadeRect: ColorRect = $FadeRect

# ===== Trạng thái =====
var IsChanging: bool = false


# ===== Hàm công khai =====
func change_scene(TargetPath: String) -> void:
	if IsChanging:
		return
	IsChanging = true
	GameState.lock_input()

	FadeRect.visible = true
	var FadeOutTween := create_tween()
	FadeOutTween.tween_property(FadeRect, "modulate:a", 1.0, 1.0)
	await FadeOutTween.finished

	get_tree().change_scene_to_file(TargetPath)

	var FadeInTween := create_tween()
	FadeInTween.tween_property(FadeRect, "modulate:a", 0.0, 1.0)
	await FadeInTween.finished

	FadeRect.visible = false
	IsChanging = false
	GameState.unlock_input()
