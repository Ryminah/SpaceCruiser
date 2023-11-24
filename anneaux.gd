extends Area3D

signal vaisseau_collided

func _on_body_entered(body):
	if body.is_in_group("Vaisseau"):
		emit_signal("vaisseau_collided")
