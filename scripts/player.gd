class_name Player extends CharacterBody2D

signal bubble_shot(bubble_scene, location)

@export var speed = 300
@export var rate_of_fire := 0.25

@onready var muzzle = $Muzzle


var bubble_scene = preload("res://bubble.tscn")

var shoot_cd := false

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", 
	"move_right"), Input.get_axis("move_up", "move_down"))
	velocity = direction * speed
	move_and_slide()

func shoot():
	bubble_shot.emit(bubble_scene, muzzle.global_position)

func die():
	queue_free()
