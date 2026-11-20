class_name PlayerCharacter
extends CharacterBody2D
## Nhân vật chính. Kiểu di chuyển đổi được theo màn chơi (SIDE / TOP_DOWN).

# ===== Kiểu di chuyển =====
enum MovementMode { SIDE, TOP_DOWN }

# ===== Hằng số =====
const Speed: float = 300.0

# ===== Node =====
@onready var AnimatedSprite: AnimatedSprite2D = $AnimatedSprite
@onready var PlayerFootstep: AudioStreamPlayer2D = $Footstep
@onready var FlashLightSound: AudioStreamPlayer2D = $FlashLightSound
@onready var Camera: Camera2D = $Camera2D
@onready var FlashLightPivot: Node2D = $FlashLightPivot
@onready var FlashLight: PointLight2D = $FlashLightPivot/FlashLight

# ===== Trạng thái =====
var Mode: MovementMode = MovementMode.TOP_DOWN
var Movement: MovementBase = TopDownMovement.new()
var FacingDirection: Vector2 = Vector2.DOWN


# ===== Vòng đời =====
func _ready() -> void:
	FlashLight.visible = false
	Camera.position_smoothing_enabled = false
	await get_tree().create_timer(0.1).timeout
	Camera.position_smoothing_enabled = true
	Camera.reset_smoothing()


func _physics_process(_delta: float) -> void:
	if GameState.is_input_locked():
		velocity = Vector2.ZERO
	else:
		var Direction: Vector2 = Movement.apply_velocity(self, Speed)
		if Direction != Vector2.ZERO:
			FacingDirection = Vector2(signf(Direction.x), signf(Direction.y))

	move_and_slide()
	_update_animation()
	_update_footstep()
	_update_flashlight_direction()


func _unhandled_input(event: InputEvent) -> void:
	if GameState.is_input_locked():
		return
	if event.is_action_pressed("toggle_flashlight") and InventoryManager.has_item("flashlight"):
		FlashLightSound.play()
		FlashLight.visible = not FlashLight.visible


# ===== Hàm công khai =====
func set_mode(NewMode: MovementMode) -> void:
	Mode = NewMode
	match Mode:
		MovementMode.SIDE:
			Movement = SideMovement.new()
		MovementMode.TOP_DOWN:
			Movement = TopDownMovement.new()


# ===== Hàm cập nhật =====
func _update_footstep() -> void:
	if velocity != Vector2.ZERO:
		if not PlayerFootstep.playing:
			PlayerFootstep.play()
	elif PlayerFootstep.playing:
		PlayerFootstep.stop()


func _update_animation() -> void:
	var IsIdle: bool = velocity == Vector2.ZERO
	var Dir: Vector2 = FacingDirection if IsIdle else Vector2(signf(velocity.x), signf(velocity.y))
	var Prefix: String = "Idle" if IsIdle else "Walk"
	var AnimName: String = ""

	if Dir.x != 0 and Dir.y != 0:
		AnimName = Prefix + ("Around" if Dir.y > 0 else "Bettween")
		AnimatedSprite.flip_h = Dir.x < 0
	elif Dir.x != 0:
		AnimName = Prefix + "Side"
		AnimatedSprite.flip_h = Dir.x < 0
	else:
		AnimName = Prefix + ("Down" if Dir.y > 0 else "Up")
		AnimatedSprite.flip_h = false

	if AnimatedSprite.animation != AnimName or not AnimatedSprite.is_playing():
		AnimatedSprite.play(AnimName)


func _update_flashlight_direction() -> void:
	FlashLightPivot.rotation = FacingDirection.angle()
