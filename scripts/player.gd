class_name Player
extends CharacterBody2D


signal health_changed(health: float)

const MAX_SPEED: float = 250.0
const ACCELERATION: float = 20.0
const JUMP_VELOCITY: float = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var health: float = 3.0
var is_jumping: bool = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false
	
	# Handle Jump.
	# Negative vertical velocity can be caused by a Spring device
	# so use 'is_jumping' to determine when air-time is player-triggered.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif Input.is_action_just_released("jump") and is_jumping:
		# Cut the jump short
		if velocity.y < 0:
			velocity.y *= 0.5
		is_jumping = false
	
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
	update_motion_anim()


func update_motion_anim() -> void:
	if %AnimationTree["parameters/Motion/current_state"] == "run":
		if !is_on_floor() || velocity.x == 0:
			%AnimationTree["parameters/Motion/transition_request"] = "idle"
	elif is_on_floor() && velocity.x != 0:
		%AnimationTree["parameters/Motion/transition_request"] = "run"


func take_damage(damage: int) -> void:
	var bounce: Vector2 = -velocity.normalized() if velocity != Vector2.ZERO else Vector2.UP
	velocity = bounce * 300
	
	health = clamp(health - damage, 0, 3.0)
	health_changed.emit(health)
	
	%AnimationTree["parameters/DmgEffect/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


# Attempts to change the health and returns whether the health was successfully changed.
func add_health(amount: float) -> bool:
	var prev_health: float = health
	
	health = clamp(health + amount, 0, 3.0)
	
	if health != prev_health:
		health_changed.emit(health)
		return true
	
	return false
