class_name SideMovement
extends MovementBase
## Góc nhìn ngang (Side view): chỉ đi trái/phải.


func get_direction() -> Vector2:
	return Vector2(Input.get_axis("move_left", "move_right"), 0.0)
