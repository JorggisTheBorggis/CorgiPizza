extends CharacterBody2D

@export var move_speed: float = 100.0
@export var acceleration: float = 400.0
@export var wait_time: float = 1.0
@export var arrival_threshold: float = 2.0

var current_speed: float = 0.0
var waiting: bool = false
var wait_timer: float = 0.0

@onready var point_a: Vector2 = $pointA.global_position
@onready var point_b: Vector2 = $pointB.global_position

var target: Vector2

func _ready():
	target = point_b

func _physics_process(delta):

	if waiting:
		wait_timer -= delta
		if wait_timer <= 0:
			waiting = false
		return

	var distance = global_position.distance_to(target)
	var direction = (target - global_position).normalized()

	var stopping_distance = (current_speed * current_speed) / (2.0 * acceleration)

	if distance <= stopping_distance:
		current_speed = move_toward(current_speed, 0.0, acceleration * delta)
	else:
		current_speed = move_toward(current_speed, move_speed, acceleration * delta)

	var movement = direction * current_speed * delta
	global_position += movement

	if distance <= arrival_threshold and current_speed < 5.0:
		global_position = target
		current_speed = 0.0
		waiting = true
		wait_timer = wait_time

		target = point_a if target == point_b else point_b
