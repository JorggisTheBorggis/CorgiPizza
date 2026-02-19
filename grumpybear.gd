extends Node2D

@export var push_force = 200
@onready var sprite: Sprite2D = $Sprite2D
@onready var tassu_area: CollisionShape2D = $Area2D/CollisionShape2D

func _physics_process(delta):
	var player = get_tree().get_nodes_in_group("Player")[0]
	if player == null:
		return

	# Bounding box check
	var tassu_global = tassu_area.global_position
	var tassu_rect = Rect2(tassu_global - tassu_area.shape.extents, tassu_area.shape.extents * 2)
	
	if tassu_rect.has_point(player.global_position):
		print("Player osuu tassuun!")
		var dir = (player.global_position - global_position).normalized()
		dir.y = 0
		player.velocity.x += dir.x * push_force
