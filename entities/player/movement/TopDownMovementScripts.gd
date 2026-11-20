class_name TopDownMovement
extends MovementBase
## Góc nhìn từ trên xuống (Top down): đi mọi hướng.


func get_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
