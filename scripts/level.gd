extends Node2D


@export var player: NodePath

@onready var player_node: CharacterBody2D = get_node_or_null(player)


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_debug()


func _update_debug() -> void:
	if !%DebugContainer.visible || !player_node:
		return
	
	%PlayerVelocity.text = "Velocity: %s" % player_node.velocity
