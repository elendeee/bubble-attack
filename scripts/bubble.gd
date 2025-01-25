extends Area2D

@export var speed = 600

func _physics_process(delta):
	global_position.x += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()