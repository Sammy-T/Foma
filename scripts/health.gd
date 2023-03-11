extends Area2D


const HEAL_AMOUNT: float = 0.5

@onready var anim_player: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_body_entered(body: Node2D) -> void:
	if !"update_health" in body:
		return
	
	# Free the node if the health was successfully added
	if body.update_health(HEAL_AMOUNT):
		if anim_player.has_animation("collect"):
			anim_player.play("collect")
		else:
			queue_free()
