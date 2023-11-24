extends Node


var score = 0
var temps = 0.0
var max_speed = 400.0
var boost = 0
var music_tracks : Array = []  # Tableau pour stocker toutes les pistes de musique
var current_track_index : int = 0  # Indice de la piste de musique actuelle
var mouse : bool = false
var bestScore = 0
var current_circuit = "res://game.tscn"
var ship_speed = 0.0
var ship
func _ready():
	# Initialisez le tableau des pistes de musique avec toutes vos pistes
	music_tracks.append(load("res://Audio/Musiques/FM Attack - Hopeless Romantic.mp3"))
	music_tracks.append(load("res://Audio/Musiques/breakcore to get my senpai to notice me.mp3"))
	music_tracks.append(load("res://Audio/Musiques/The Thing in the Night.mp3"))
	music_tracks.append(load("res://Audio/Musiques/2 minute.mp3"))
	music_tracks.append(load("res://Audio/Medieval Music – Court Minstrel.mp3"))
