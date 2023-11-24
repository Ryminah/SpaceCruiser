extends CharacterBody3D
	

@export var acceleration = 1.0
@export var pitch_speed = 2.5
@export var roll_speed = 2.9
@export var yaw_speed = 2.25

@onready var particles = $ReacteurParticles
@onready var speedParticles = $SpeedParticles
@onready var boostParticles = $BoostParticles
@onready var lights = $Lumieres
@onready var camera1 = $Cameras/CameraDerriere
@onready var cameraRef = $Cameras/CameraStable
@onready var canon = $Coque/Canons/Canon/RayCast3D
@onready var canon2 = $Coque/Canons/Canon2/RayCast3D
var forward_speed = 0.0
var pitch_input = 0.0
var roll_input = 0.0
var yaw_input = 0.0
var currentCanonIndex = 0  # Variable pour suivre l'index du canon actuel
var timing = 0.0
var life = 100.0
#Bullets 
var bullet = load("res://bullet.tscn")

var instance
func _ready():
	velocity = Vector3.ZERO
	camera1.top_level = true
	cameraRef.current = true
	$Sounds/Music.stream = Global.music_tracks[Global.current_track_index]
	$Sounds/Music.play()

func _enter_tree():
	set_multiplayer_authority(name.to_int())
#Function permettant de récupérer tout les inputs nécessaires
func _get_input(delta):
	#Partie Input a la souris si le mode est coché depuis le menu :
	var deadzone_top_left = Vector2(get_viewport().size.x / 4, get_viewport().size.y / 4)
	var deadzone_bottom_right = Vector2(get_viewport().size.x * 3 / 4, get_viewport().size.y * 3 / 4)
	var mouse_position = get_viewport().get_mouse_position()
	var center = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	var mouse_deadzone_radius = 50.0  # Rayon de la zone centrale où la souris n'a pas d'effet
	var mouse_delta = mouse_position - Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	
	if Global.mouse:
		#Yaw with mouse
		if mouse_position.x < deadzone_top_left.x:
			yaw_input = clamp(yaw_input + mouse_delta.x * 0.01, -0.5, 0.5)  # Bornes minimale et maximale inversées
		if mouse_position.x > deadzone_bottom_right.x:
			yaw_input = clamp(yaw_input - mouse_delta.x * -0.01, -0.5, 0.5)  # Bornes minimale et maximale inversées

		# Pitch with mouse
		if mouse_position.y < deadzone_top_left.y:
			pitch_input = clamp(pitch_input + mouse_delta.y * 0.01, -0.5, 0.5)  # Bornes minimale et maximale inversées
		if mouse_position.y > deadzone_bottom_right.y:
			pitch_input = clamp(pitch_input - mouse_delta.y * -0.01, -0.5, 0.5)  # Bornes minimale et maximale inversées

		

	if Input.is_action_pressed("throttle_up"):
		if forward_speed <= Global.max_speed:
			var target_speed = lerp(forward_speed, Global.max_speed, 0.1)  # 0.1 est un facteur de lissage
			forward_speed = target_speed
		for particle in particles.get_children():
			particle.set_emitting(true) 
	if Input.is_action_just_pressed("throttle_up"):
		$Sounds/Thruster.play()
	
	#Lorsque le boost est appuyé, emet des particules, augmente la vitesse et réduit la barre de boost
	if Global.boost > 0:
		if Input.is_action_pressed("boost") and Global.boost > 0:
			var target_speed = lerp(forward_speed, Global.max_speed + 200, acceleration * delta * 5)  # 0.1 est un facteur de lissage
			forward_speed = target_speed
			Global.boost -= 0.25
			for particle in speedParticles.get_children():
				particle.set_emitting(true)
			for particle in boostParticles.get_children():
				particle.set_emitting(true)
			if Input.is_action_just_pressed("boost"):
				$Sounds/Boost.play()
				
	#Lorsque la vitesse est trop faible		
	if forward_speed < Global.max_speed + 30:
		for particle in speedParticles.get_children():
				particle.set_emitting(false) 
	
	#Lorsque le boost n'est plus appuyé ou qu'il n'y plus de boost
	#Ralenti la vitesse à la vitesse maximal basique, et enlève les particules de boost
	if !(Input.is_action_pressed("boost")) && forward_speed > Global.max_speed or Global.boost == 0 :
		forward_speed = lerp(forward_speed, Global.max_speed, acceleration * delta)		
		$Sounds/Boost.stop()
		for particle in boostParticles.get_children():
				particle.set_emitting(false)
				
	#Ralentissement du vaisseau
	if Input.is_action_pressed("throttle_down"):
		forward_speed = lerp(forward_speed, 0.0, acceleration * delta)
		
	#Changement de vue du vaisseau
	if Input.is_action_just_pressed("camera_swap"):
		if camera1.current:
			cameraRef.current = true
		else:
			camera1.current = true
  
	var target_pitch_input = Input.get_action_strength("pitch_down") - Input.get_action_strength("pitch_up")
	pitch_input = lerp(pitch_input, target_pitch_input, 0.1)  # 0.1 est un facteur de lissage

	var target_roll_input = Input.get_action_strength("roll_right") - Input.get_action_strength("roll_left")
	roll_input = lerp(roll_input, target_roll_input, 0.1)  # 0.1 est un facteur de lissage
	
	var target_yaw_input = Input.get_action_strength("yaw_left") - Input.get_action_strength("yaw_right")
	yaw_input = lerp(yaw_input, target_yaw_input, 0.1) 
	
	#Permet d'arreter les particules ainsi que le son du propulseur quand la touche est relachée
	if Input.is_action_just_released("throttle_up") or Input.is_action_pressed("boost"):
		$Sounds/Thruster.stop()		
		for particle in particles.get_children():
			particle.set_emitting(false)
			
	#Tirer depuis les canons
	if Input.is_action_pressed("shoot"):
		var canons = $Coque/Canons.get_children()
		if canons.size() > 0 and timing > 0.08:
			$Sounds/Shot.play()
			var currentCanon = canons[currentCanonIndex]
			var instance = bullet.instantiate()
			instance.position = currentCanon.global_position
			instance.transform.basis = currentCanon.global_transform.basis
			instance.add_to_group("bullet")  # Ajoutez la balle au groupe "bullet"
			get_parent().add_child(instance)
			currentCanonIndex += 1
			if currentCanonIndex >= canons.size():
				currentCanonIndex = 0  # Réinitialisez l'index si tous les canons ont été utilisés
			timing = 0.0
#Fonction permettant la vue cinématique
func _camera_tracking():
	camera1.global_position.x = global_position.x
	camera1.global_position.y = global_position.y + 5
	camera1.global_position.z = global_position.z - 8

func _lose_hp():
	life -= 5
	
func _physics_process(delta):
	_camera_tracking()
	_get_input(delta)
	timing += delta
	#Gestion du fov de la caméra
	if forward_speed > Global.max_speed + 50 && camera1.fov < 130 && cameraRef.fov < 130:
		camera1.fov +=1
		cameraRef.fov += 1
	elif forward_speed < Global.max_speed + 30 && camera1.fov > 75 && cameraRef.fov > 75:
		camera1.fov -= 2
		cameraRef.fov -= 2

	Global.ship_speed = forward_speed
	#Déplacements du vaisseau
	%Speed.text = str("%.0f" % velocity.length() + "m/s")
	var target_basis = transform.basis.rotated(transform.basis.z, roll_input * roll_speed * delta)
	target_basis = target_basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	target_basis = target_basis.rotated(transform.basis.y, yaw_input * yaw_speed * delta)
	transform.basis = lerp(transform.basis, target_basis, 1)  # 0.1 est un facteur de lissage
	transform.basis = transform.basis.orthonormalized()
	velocity = transform.basis.z * forward_speed
	move_and_collide(velocity * delta)


func _on_area_3d_body_entered(body):
	if body.is_in_group("bullet"):
		_lose_hp()
	
