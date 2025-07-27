extends CharacterBody2D

@export var speed = 300.0
@export var jump_force = -500.0
@export var gravity = 980.0
@export var friction = 2000.0

# Jump related stuff
@export var jump_count : int = 2
var current_jump_count : int
var can_multi_jump : bool = false

@export var knockbackmultiplyer : float = 1
var isright : bool = false

@export var UI : Control

func _ready() -> void:
	current_jump_count = jump_count

### --- Improved Knockback Function ---
# This function applies knockback as an impulse. It directly sets the
# character's velocity in a single frame.
func apply_knockback(force: Vector2):
	velocity = force * knockbackmultiplyer
	knockbackmultiplyer += 0.05


func _physics_process(delta):
	# Test key to demonstrate the new knockback
	if Input.is_action_just_pressed("testkey"):
		# The caller now defines the full knockback vector (direction and strength).
		# This sends the character up and to the left.
		if isright == true:
			apply_knockback(Vector2(-800, -200))
		else:
			apply_knockback(Vector2(800, -200))
	
	# Apply gravity. We only apply it when airborne.
	# This will also naturally pull the character down from a knockback.
	var foo : Label = UI.KnockbackLabel
	foo.text = "Knockback: " + str(knockbackmultiplyer) + "x"
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Reset jump state when landing
	if is_on_floor():
		current_jump_count = jump_count
		can_multi_jump = false
		
	# Handle horizontal movement
	# This code will now "fight against" the knockback's horizontal velocity,
	# allowing the player to regain control (also known as Directional Influence).
	var input_direction = Input.get_axis("move_left", "move_right")
	var target_velocity_x = input_direction * speed
	velocity.x = move_toward(velocity.x, target_velocity_x, friction * delta)

	# Handle jumping (your original logic)
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

	# Handle cutting a jump short
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5 # Immediately reduce upward speed
	
	if velocity.x != 0:
		if velocity.x > 0:
			isright = true
		else:
			isright = false
	
	if Input.is_action_pressed("down"):
		gravity = 980 * 4
	else:
		gravity = 980
	print(gravity)
	
	# Move the character
	move_and_slide()

# The timer and its timeout function are no longer needed.
# func _on_timer_timeout() -> void: -> REMOVED
