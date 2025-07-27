extends Area2D

@export var knockback : Vector2 = Vector2(0, -500)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.apply_knockback(knockback)
