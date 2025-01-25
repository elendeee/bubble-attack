extends Control

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var bubble_container = $BubbleContainer

var player = null

func _ready():
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
