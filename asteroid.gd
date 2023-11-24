extends Area3D
signal vaisseau_collided_asteroid
# Minimum speed of the mob in meters per second.
@export var min_speed = 10
var hp = 100
# Maximum speed of the mob in meters per second.
@export var max_speed = 18

func _on_body_entered(body):
	if body.is_in_group("Vaisseau"):
		emit_signal("vaisseau_collided_asteroid")
	elif body.is_in_group("bullet"):
		_lose_hp()
		body.queue_free()
		
func _lose_hp():
	hp -= 5
	$SubViewport/healthbar.value -= 5
	
func initialize(start_position, player_position):
	# ...

	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.

func _physics_process(_delta):
	if hp == 0:
		queue_free()
