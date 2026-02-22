extends Node2D

var player_in_range := false
@export var slap_cooldown: float = 1.0

var can_slap := true

func _ready():
	$DetectionArea.body_entered.connect(_on_body_entered)
	$DetectionArea.body_exited.connect(_on_body_exited)



func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		print("Player entered range")


func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		print("Player left range")
func _process(delta):
	if player_in_range and can_slap:
		slap()
		
func slap():
	can_slap = false
	print("SLAP")
	
	# Later we play animation here
	
	await get_tree().create_timer(slap_cooldown).timeout
	can_slap = true
