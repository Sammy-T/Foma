extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	
	%RetryButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
