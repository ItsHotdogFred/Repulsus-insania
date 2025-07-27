extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D

var speed = 4500
var player : CharacterBody2D

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


func _on_timer_timeout() -> void:
	make_path(player.global_position)
