extends Control

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func set_score(value):
	$Panel/Score.text = "Score: " + str(value)
	
func set_high_score(value):
	$Panel/HighScore.text = "High Score: " + str(value)	


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
