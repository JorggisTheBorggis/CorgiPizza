extends Area2D
@onready var shape = $Blob
@onready var sprite = $Slice
@onready var sound = $AudioStreamPlayer2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		sound.play()
		shape.disabled = true
		sprite.visible = false
		await sound.finished
		queue_free()
