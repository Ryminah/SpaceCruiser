extends Node3D

@export var mob_scene: PackedScene


var currentRingIndex = 0  # Variable pour suivre l'anneau à afficher
@onready var anneaux = $Anneaux.get_children()
var ringsToRemove = []  # Liste pour suivre les anneaux à supprimer
@onready var asteroids = $Asteroids.get_children()
@onready var deathcam = $DeathCam



# Called when the node enters the scene tree for the first time.
func _ready():
	%Boosts.text = str(Global.boost)
	%Points.text = str(Global.score)
	for anneau in anneaux:
		anneau.vaisseau_collided.connect(_on_vaisseau_collision_anneau)
	for asteroid in asteroids:
		asteroid.vaisseau_collided_asteroid.connect(_on_vaisseau_collision_asteroid)
	$Finish.vaisseau_ended.connect(_on_finish)
	$Pause.hide()
	
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))

func _on_finish():
	get_tree().change_scene_to_file("res://Menus/EcranScore.tscn")

func _on_vaisseau_collision_anneau():
	Global.score += 1
	if Global.boost <= 75:
		Global.boost += 25
	if Global.boost > 75:
		Global.boost += 100 - Global.boost
	$Ship/RingGet.play()
	%Points.text = str(Global.score)
	# Cacher l'anneau actuel
	if currentRingIndex < anneaux.size():
		ringsToRemove.append(anneaux[currentRingIndex])
	# Cacher l'anneau actuel (si possible)
	if currentRingIndex < anneaux.size():
		anneaux[currentRingIndex].hide()
		
	# Choisir le prochain anneau à afficher (peut-être au hasard)z
	currentRingIndex += 1
	# Supprimer les anneaux de la liste
	for ring in ringsToRemove:
		ring.queue_free()
	# Vider la liste des anneaux à supprimer
	ringsToRemove.clear()
	# Afficher le nouvel anneau
	if currentRingIndex < anneaux.size():
		anneaux[currentRingIndex].show()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_vaisseau_collision_asteroid():
	get_tree().change_scene_to_file("res://Menus/deathMenu.tscn")
	
func _get_input(delta):
	if Input.is_action_just_pressed("menu"):
		$Pause.show()
		get_tree().paused = true
		
func _process(delta):
	_get_input(delta)
	%Boosts.text = str("%.0f" % Global.boost + "%")

