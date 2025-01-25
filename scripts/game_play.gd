extends Control

@export var enemy_scenes: Array[PackedScene] = []

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var bubble_container = $BubbleContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score

func _ready():
	score = 0
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	player.global_position = player_spawn_pos.global_position
	player.bubble_shot.connect(_on_player_bubble_shot)
	
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
func _on_player_bubble_shot(bubble_scene, location):
		var bubble = bubble_scene.instantiate()
		bubble.global_position = location
		bubble_container.add_child(bubble)

func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(1300, 1700), randf_range(90, 600))
	e.killed.connect(_on_enemy_killed)
	enemy_container.add_child(e)
	
func _on_enemy_killed(points):
	score += points
	print(score)
	
