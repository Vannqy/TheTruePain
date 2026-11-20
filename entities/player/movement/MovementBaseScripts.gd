class_name MovementBase
extends RefCounted
## Lớp cha cho mọi kiểu di chuyển. Kiểu mới (leo thang, bơi...) chỉ cần kế thừa và ghi đè get_direction().


func get_direction() -> Vector2:
	return Vector2.ZERO


## Gán velocity cho Body và trả về hướng input (để Player cập nhật hướng nhìn).
func apply_velocity(Body: CharacterBody2D, Speed: float) -> Vector2:
	var Direction: Vector2 = get_direction()
	Body.velocity = Direction * Speed
	return Direction
