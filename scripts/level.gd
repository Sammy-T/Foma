extends Node2D


const GameOver: PackedScene = preload("res://scenes/gui/game_over.tscn")
const PauseMenu: PackedScene = preload("res://scenes/gui/pause_menu.tscn")

@export var player: CharacterBody2D
@export var next_level: PackedScene

var coin_count: int = 0

@onready var debug_container: MarginContainer = %DebugContainer
@onready var player_debug: Label = %PlayerDebug
@onready var health_display: Label = %HealthAmt
@onready var coin_display: Label = %CoinCount


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Use call_deferred to allow the TileMap's scene tiles to be instantiated
	# before trying to access them. (https://github.com/godotengine/godot/issues/57567)
	call_deferred("_init_scene_tiles")
	
	_update_health_display(player.health)
	
	player.health_changed.connect(_update_health_display)
	player.player_died.connect(_on_player_death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_debug()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		var pause_menu: Node = PauseMenu.instantiate()
		%CanvasLayer.add_child(pause_menu)


# A helper used in deferring access to the TileMap's instantiated scene tiles
func _init_scene_tiles() -> void:
	var valuables: Array[Node] = get_tree().get_nodes_in_group("valuable")
	var complete_flags: Array[Node] = get_tree().get_nodes_in_group("complete_flag")
	
	for valuable in valuables:
		valuable.valuable_collected.connect(_update_coin_count)
	
	for flag in complete_flags:
		flag.level_complete.connect(_on_level_complete)


func _update_debug() -> void:
	if !debug_container.visible || !player:
		return
	
	player_debug.text = "Velocity: %s" % Vector2i(player.velocity)


func _update_coin_count(value: int) -> void:
	coin_count += value
	coin_display.text = "x%d" % coin_count


func _update_health_display(health: float) -> void:
	health_display.text = "%s" % health


func _on_player_death() -> void:
	# Display the Game Over menu
	var game_over: Node = GameOver.instantiate()
	%CanvasLayer.add_child(game_over)


func _on_level_complete() -> void:
	if !next_level:
		## TODO: Display Game Finished menu
		printerr("%s %s - No next level to load" \
				% [Time.get_time_string_from_system(), self.name])
		return
	
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_packed(next_level)
