extends Area2D


const SPRING_VELOCITY: float = -700.0

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var sfx_bounce: AudioStreamPlayer = %Bounce


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_body_entered(body: Node2D) -> void:
	if !body is Player:
		printerr("%s Error: Found %s instead of Player" % [self.name, body])
		return
	
	animated_sprite.play("default") # Play the bounce animation
	sfx_bounce.play() # Play the bounce sfx
	
	# Ensure the bounce doesn't get confused with player input.
	# This can happen if the player jumps onto a Spring and releases the jump
	# after bouncing.
	body.is_jumping = false
	
	body.velocity.y = SPRING_VELOCITY # Use the spring's velocity to bounce the player
