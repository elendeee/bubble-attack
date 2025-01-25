class_name Enemy extends Area2D

@export var speed = 150
@export var hp = 1

func _physics_process(delta):
	global_position.x += -speed * delta

func die():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.die()
		die()
		
func take_damage(amount):
	hp -= amount
	if hp <= 0:
		die()
