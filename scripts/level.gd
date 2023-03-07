extends Node2D


@export var player: CharacterBody2D

var coin_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var coins: Array[Node] = get_tree().get_nodes_in_group("coin")
	
	for coin in coins:
		coin.coin_collected.connect(_update_coin_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_debug()


func _update_debug() -> void:
	if !%DebugContainer.visible || !player:
		return
	
	%PlayerVelocity.text = "Velocity: %s" % Vector2i(player.velocity)


func _update_coin_count() -> void:
	coin_count += 1
	%CoinCount.text = "x%d" % coin_count
