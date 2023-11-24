extends MeshInstance3D


var rotation_speed : float = 1.0  # Vitesse de rotation (en radians par seconde)

func _process(delta):
	# Calculez la rotation en radians
	var rotation_vector = Vector3(0.5, rotation_speed * delta, 0.5)
	# Assurez-vous que le vecteur de rotation est normalisé
	if !rotation_vector.is_normalized():
		rotation_vector = rotation_vector.normalized()
	
	# Utilisez la fonction rotate avec le vecteur normalisé
	rotate(rotation_vector, 0.01)
