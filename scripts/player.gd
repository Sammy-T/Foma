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
var is_taking_dmg: bool = false

@onready var anim_tree: AnimationTree = %AnimationTree


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
		if velocity.y < 0:
			velocity.y *= 0.5 # Cut the jump short
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
	update_anim_state()
	update_particle_state(direction)


func update_anim_state() -> void:
	if anim_tree["parameters/Motion/current_state"] == "run":
		if !is_on_floor() || velocity.x == 0:
			anim_tree["parameters/Motion/transition_request"] = "idle"
	elif is_on_floor() && velocity.x != 0:
		anim_tree["parameters/Motion/transition_request"] = "run"


func update_particle_state(direction: float) -> void:
	if direction != 0 && is_on_floor():
		%RunParticles.emitting = true
		%RunParticles.process_material.direction.x = 1 if direction > 0 else -1
	else:
		%RunParticles.emitting = false


# Attempts to change the health and returns whether the health was successfully changed.
func update_health(delta: float) -> bool:
	if delta < 0:
		if is_taking_dmg:
			return false # Return early if already taking damage (e.g. hitting multiple Spikes)
		
		is_taking_dmg = true
		
		# Bounce the player
		var bounce: Vector2 = -velocity.normalized() if velocity != Vector2.ZERO else Vector2.UP
		velocity = bounce * 300
		
		# Play the damage animation
		anim_tree["parameters/DmgEffect/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
	var prev_health: float = health
	
	health = clamp(health + delta, 0, 3.0) # Update the health
	health_changed.emit(health)
	
	return health != prev_health


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"take_damage":
			is_taking_dmg = false
