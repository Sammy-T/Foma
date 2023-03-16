extends VBoxContainer


const MainMenu: PackedScene = preload("res://scenes/gui/main_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	
	%ResumeButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		_resume_scene()
		get_viewport().set_input_as_handled()


func _on_button_focus_entered() -> void:
	%SelectSound.play()


func _on_resume_button_pressed() -> void:
	_resume_scene()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(MainMenu)


func _resume_scene() -> void:
	get_tree().paused = false
	queue_free()
