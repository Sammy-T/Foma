extends Node2D


@export var player: CharacterBody2D

var coin_count: int = 0

@onready var debug_container: MarginContainer = %DebugContainer
@onready var player_debug: Label = %PlayerDebug
@onready var health_display: Label = %HealthAmt
@onready var coin_display: Label = %CoinCount


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Use call_deferred to allow the TileMap's scene tiles to be instantiated
	# before trying to access them. (https://github.com/godotengine/godot/issues/57567)
	call_deferred("_init_valuables")
	
	_update_health_display(player.health)
	player.health_changed.connect(_update_health_display)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_debug()


# A helper used in deferring access to the TileMap's instantiated scene tiles
func _init_valuables() -> void:
	var valuables: Array[Node] = get_tree().get_nodes_in_group("valuable")
	
	for valuable in valuables:
		valuable.valuable_collected.connect(_update_coin_count)


func _update_debug() -> void:
	if !debug_container.visible || !player:
		return
	
	player_debug.text = "Velocity: %s" % Vector2i(player.velocity)


func _update_coin_count(value: int) -> void:
	coin_count += value
	coin_display.text = "x%d" % coin_count


func _update_health_display(health: float) -> void:
	health_display.text = "%s" % health
