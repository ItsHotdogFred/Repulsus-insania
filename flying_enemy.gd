extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D

var speed = 4500
var player : CharacterBody2D

@export var knockback : Vector2 = Vector2(0, 0)

func _ready() -> void:
	player = get_parent().player
	#nav_agent.navigation_finished.connect(_on_nav_finished)
	nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	make_path(player.global_position)
	
#func _on_nav_finished():
	#make_path(player.global_position)
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity,100)
	move_and_slide()
	
func make_path(pos: Vector2):
	nav_agent.target_position = pos



func _physics_process(delta: float) -> void:
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	var new_velocity = direction * speed * delta
	
	nav_agent.velocity = new_velocity
	if velocity.length() > 0:
		# 3. Get the direction by normalizing the velocity vector.
		# The .normalized() method returns a unit vector (length of 1)
		# that points in the same direction as the original vector.
		knockback = velocity.normalized() * 450
	else:
		# If the node isn't moving, there is no direction.
		knockback = Vector2.ZERO


func _on_timer_timeout() -> void:
	make_path(player.global_position)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.apply_knockback(knockback)
