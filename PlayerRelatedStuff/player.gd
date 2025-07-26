extends CharacterBody2D

@export var speed = 200.0
@export var jump_force = -400.0
@export var gravity = 980.0
@export var friction = 2000.0

# Jump related stuff
@export var jump_count : int = 2
var current_jump_count : int
var can_multi_jump : bool = false


func _ready() -> void:
	current_jump_count = jump_count

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	if is_on_floor():
		current_jump_count = jump_count
		can_multi_jump = false
		
	# Handle horizontal movement
	var input_direction = Input.get_axis("move_left", "move_right")
	var target_velocity_x = input_direction * speed
	velocity.x = move_toward(velocity.x, target_velocity_x, friction * delta)

	# Handle jumping
	if Input.is_action_just_pressed("jump"):
		# Initial jump from the floor
		if is_on_floor():
			velocity.y = jump_force
			current_jump_count -= 1
			can_multi_jump = true # Enable multi-jumping after the first jump
		# Multi-jump while in the air
		elif can_multi_jump and current_jump_count > 0:
			velocity.y = jump_force
			current_jump_count -= 1

	# Add this code to handle cutting a jump short
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5 # Immediately reduce upward speed
	# Move the character
	move_and_slide()
