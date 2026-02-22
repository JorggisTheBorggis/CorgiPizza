extends CharacterBody2D

# --- PLAYER STATS ---
@export var max_speed: float = 350
@export var acceleration: float = 500
@export var friction: float = 800
@export var turn_friction: float = 1600
@export var jump_force: float = -500
@export var gravity: float = 1000
@export var air_control: float = 0.68


# --- COYOTE / BUFFER ---
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

# --- FALL / JUMP MULTIPLIERS ---
@export var fall_multiplier: float = 1.5
@export var low_jump_multiplier: float = 2.0

# --- CAMERA ---
@export var camera_smooth: float = 0.01
@export var camera_lookahead: float = 0.75

@onready var cam: Camera2D = $PlayerCamera


func _physics_process(delta):

	# --- COYOTE TIME ---
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# --- JUMP BUFFER ---
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# --- GRAVITY ---
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * fall_multiplier * delta
		elif velocity.y < 0 and not Input.is_action_pressed("ui_accept"):
			velocity.y += gravity * low_jump_multiplier * delta
		else:
			velocity.y += gravity * delta

	# --- INPUT ---
	var direction = Input.get_axis("ui_left", "ui_right")

	# --- MOVEMENT ---
	if is_on_floor():

		var target_speed = direction * max_speed

		if direction != 0:
			if sign(direction) != sign(velocity.x) and velocity.x != 0:
				velocity.x = move_toward(
					velocity.x,
					target_speed,
					turn_friction * delta
				)
			else:
				velocity.x = move_toward(
					velocity.x,
					target_speed,
					acceleration * delta
				)
		else:
			velocity.x = move_toward(
				velocity.x,
				0.0,
				friction * delta
			)

	else:
		# AIR MOVEMENT
		if direction != 0:
			var air_target = direction * max_speed * air_control
			velocity.x = move_toward(
				velocity.x,
				air_target,
				acceleration * air_control * delta
			)

	# --- JUMP ---
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_force
		jump_buffer_timer = 0
		coyote_timer = 0

	# --- MOVE ---
	move_and_slide()

	# --- SPRITE TURN ---
	if velocity.x != 0:
		$Sprite2D.flip_h = velocity.x > 0

	# --- CAMERA ---
	var target_offset = Vector2(velocity.x * camera_lookahead, 0)
	cam.offset = cam.offset.lerp(target_offset, camera_smooth)
