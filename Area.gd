extends MeshInstance3D

func _on_body_entered(body):
	if body is CharacterBody3D:  # Remplacez "Vaisseau" par le nom de votre vaisseau ou du type d'objet que vous voulez détecter
		# Vaisseau a traversé l'anneau
		print("Vaisseau a traversé l'anneau")

func _on_Area_body_exited(body):
	if body is CharacterBody3D:
		# Vaisseau est sorti de l'anneau
		print("Vaisseau est sorti de l'anneau")
