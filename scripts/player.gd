extends CharacterBody2D

signal bubble_shot(bubble_scene, location)

@export var speed = 300

@onready var muzzle = $Muzzle

var bubble_scene = preload("res://bubble.tscn")

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", 
	"move_right"), Input.get_axis("move_up", "move_down"))
	velocity = direction * speed
	move_and_slide()

func shoot():
	bubble_shot.emit(bubble_scene, muzzle.global_position)
