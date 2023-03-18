class_name Player
extends CharacterBody2D


signal health_changed(health: float)
signal player_died

const MAX_SPEED: float = 250.0
const ACCELERATION: float = 20.0
const JUMP_VELOCITY: float = -350.0
const MOVEMENT_TILT: float = PI / 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var health: float = 3.0
var is_jumping: bool = false
var is_in_coyote_time: bool = false
var is_taking_dmg: bool = false
var was_on_floor: bool = false

@onready var sprite: Sprite2D = %Sprite2D
@onready var anim_tree: AnimationTree = %AnimationTree
@onready var run_particles: GPUParticles2D = %RunParticles
@onready var coyote_timer: Timer = %CoyoteTimer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false
		_cancel_coyote_time()
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and can_jump():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		_cancel_coyote_time()
		%Jump.play()
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
	
	# Face and tilt the player towards the movement direction
	if direction != 0:
		sprite.flip_h = direction > 0
		rotation = direction * MOVEMENT_TILT
	else:
		rotation = 0
	
	move_and_slide()
	
	_check_coyote_time()
	
	update_anim_state()
	update_particle_state(direction)
	
	was_on_floor = is_on_floor()


# A helper to determine whether the player can jump.
# (Negative vertical velocity can be caused by a Spring device
# so use 'is_jumping' to determine when air-time is player-triggered.)
func can_jump() -> bool:
	return is_on_floor() || (!is_jumping && is_in_coyote_time)


# Checks if the player has just left the floor but isn't jumping, then initiates coyote time.
# (This apparently must be done after move_and_slide 
# to catch the 'is' <-> 'was' [_on_floor] transition.)
func _check_coyote_time() -> void:
	if not is_on_floor() and was_on_floor and not is_jumping:
		is_in_coyote_time = true
		coyote_timer.start()


# A helper to stop coyote time
func _cancel_coyote_time() -> void:
	if is_in_coyote_time:
		is_in_coyote_time = false
		coyote_timer.stop()


func update_anim_state() -> void:
	if anim_tree["parameters/Motion/current_state"] == "run":
		if !is_on_floor() || velocity.x == 0:
			anim_tree["parameters/Motion/transition_request"] = "idle"
	elif is_on_floor() && velocity.x != 0:
		anim_tree["parameters/Motion/transition_request"] = "run"
	
	# Play the landing animation when contacting the floor
	if is_on_floor() && !was_on_floor:
		anim_tree["parameters/LandingEffect/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func update_particle_state(direction: float) -> void:
	if direction != 0 && is_on_floor():
		run_particles.emitting = true
		run_particles.process_material.direction.x = 1 if direction > 0 else -1
	else:
		run_particles.emitting = false


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
	
	if health == 0:
		anim_tree["parameters/Motion/transition_request"] = "death"
	
	return health != prev_health


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"take_damage":
			is_taking_dmg = false


func _on_coyote_timer_timeout() -> void:
	is_in_coyote_time = false
