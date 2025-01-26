extends Control

@export var enemy_scenes: Array[PackedScene] = []

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var bubble_container = $BubbleContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen
@onready var pb = $ParallaxBackground

@onready var bubble_sound = $SFX/BubbleSound
@onready var pop_sound = $SFX/PopSound
@onready var lose_sound = $SFX/LoseSound

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score

var scroll_speed = 100

func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!=null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()	
	
	score = 0
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	player.global_position = player_spawn_pos.global_position
	player.bubble_shot.connect(_on_player_bubble_shot)
	player.killed.connect(_on_player_killed)
	
func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.005
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5
	
	pb.scroll_offset.x += delta * scroll_speed
		
func _on_player_bubble_shot(bubble_scene, location):
		var bubble = bubble_scene.instantiate()
		bubble.global_position = location
		bubble_container.add_child(bubble)
		bubble_sound.play()

func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(1300, 1700), randf_range(90, 600))
	e.killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_container.add_child(e)
	
func _on_enemy_killed(points):
	pop_sound.play()
	score += points
	if score > high_score:
		high_score = score

func _on_enemy_hit():
	pop_sound.play()

func _on_player_killed():
	lose_sound.play()
	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(0.8).timeout
	gos.visible = true
