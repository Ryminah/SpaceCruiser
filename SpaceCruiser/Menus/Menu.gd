extends Control


# Called when the node enters the scene tree for the first time.



	# Ajoutez d'autres pistes de musique au tableau au besoin
	# Chargez et jouez la première piste de musique au démarrage
func _ready():
	$Musique.stream = Global.music_tracks[Global.current_track_index]
	$Musique.play()


func _on_start_button_pressed():
	Global.score = 0
	Global.temps = 0
	Global.boost = 0
	get_tree().change_scene_to_file(Global.current_circuit)


func _on_quit_buttons_pressed():
	get_tree().quit()

func _process(delta):
	%Music.text = str(Global.current_track_index + 1)
	_text_parcours()
func _on_musique_pressed():
	Global.current_track_index = (Global.current_track_index + 1) % Global.music_tracks.size()  # Passez à la piste suivante (circulaire)
	# Jouez la nouvelle piste de musique
	$Musique.stream = Global.music_tracks[Global.current_track_index]
	$Musique.play()


func _on_check_button_pressed():
	if Global.mouse:
		Global.mouse = false
	else:
		Global.mouse = true


func _text_parcours():
	if Global.current_circuit == "res://game.tscn":
		%Parcours.text = "Parcours Classique"
	elif Global.current_circuit == "res://game1.tscn":
		%Parcours.text = "Parcours Cauchemard"	
		
func _on_parcours_suivant_pressed():
	if Global.current_circuit == "res://game.tscn":
		Global.current_circuit = "res://game1.tscn"
	else:
		Global.current_circuit = "res://game.tscn"
	
