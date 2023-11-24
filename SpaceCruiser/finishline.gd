extends Area3D

signal vaisseau_ended

# Called when the node enters the scene tree for the first time.

func _on_body_entered(body):
		if body.is_in_group("Vaisseau"):
			emit_signal("vaisseau_ended")

