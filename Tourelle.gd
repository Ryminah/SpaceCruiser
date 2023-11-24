extends Node3D

@onready var canon = $canons/Canon
@onready var canon2 = $canons/Canon2
var timing = 0.0
var currentCanonIndex = 0  # Variable pour suivre l'index du canon actuel
var bullet = load("res://bullet.tscn")
var instance
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _shoot():
	var canons = $canons.get_children()
	if canons.size() > 0 and timing > 0.08:

		var currentCanon = canons[currentCanonIndex]
		var instance = bullet.instantiate()
		instance.position = currentCanon.global_position
		instance.transform.basis = currentCanon.global_transform.basis
		get_parent().add_child(instance)
		currentCanonIndex += 1
		if currentCanonIndex >= canons.size():
			currentCanonIndex = 0  # Réinitialisez l'index si tous les canons ont été utilisés
		timing = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timing += delta
	$Tir.play()
	_shoot()
