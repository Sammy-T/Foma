extends VBoxContainer


const MainMenu: PackedScene = preload("res://scenes/gui/main_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	
	%RetryButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(MainMenu)
