extends Area2D


signal valuable_collected(value: int)

@export var value: int = 1


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_body_entered(_body: Node2D) -> void:
	valuable_collected.emit(value)
	queue_free()
