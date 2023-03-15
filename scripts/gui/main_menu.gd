extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_play_button_pressed() -> void:
	# Use change by file instead of PackedScene. This prevents a cyclic error
	# since I'm preloading the main menu via the menus in the level scenes.
	# I don't recall this being an issue while using v3.x.x.
	# (https://github.com/godotengine/godot/pull/67714)
	# (https://github.com/godotengine/godot/issues/72921#issuecomment-1423244325)
	get_tree().change_scene_to_file("res://scenes/levels/level_01.tscn")
