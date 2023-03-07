class_name Player
extends CharacterBody2D


const MAX_SPEED: float = 250.0
const ACCELERATION: float = 20.0
const JUMP_VELOCITY: float = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction: float = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	# Face the sprite to the movement direction
	if direction != 0:
		$Sprite2D.flip_h = direction > 0
		$Sprite2D.rotation = direction * PI / 30
	else:
		$Sprite2D.rotation = 0
	
	move_and_slide()
	update_anim()


func update_anim() -> void:
	if %AnimationPlayer.is_playing():
		if !is_on_floor() || velocity.x == 0:
			%AnimationPlayer.play("RESET")
	elif is_on_floor() && velocity.x != 0:
		%AnimationPlayer.play("run")
