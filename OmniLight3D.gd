extends OmniLight3D

var colors = [
	Color(1.0, 0.0, 0.0),  # Rouge
	Color(1.0, 0.5, 0.0),  # Orange
	Color(1.0, 1.0, 0.0),  # Jaune
	Color(0.0, 1.0, 0.0),  # Vert
	Color(0.0, 0.0, 1.0),  # Bleu
	Color(0.5, 0.0, 1.0)   # Violet
]

var current_color_index = randi() % colors.size()  # Sélection aléatoire de la couleur initiale
var next_color_index = (current_color_index + 1) % colors.size()
var transition_duration = 1.0  # Durée de transition en secondes
var transition_timer = 0.0

func _ready():
	set_process(true)
	set_color(colors[current_color_index])

func _process(delta):
	transition_timer += delta
	if transition_timer >= transition_duration:
		transition_timer = 0.0
		current_color_index = next_color_index
		next_color_index = (current_color_index + 1) % colors.size()
	
	var current_color = colors[current_color_index]
	var next_color = colors[next_color_index]
	
	var lerp_color = Color(
		lerp(current_color.r, next_color.r, transition_timer / transition_duration),
		lerp(current_color.g, next_color.g, transition_timer / transition_duration),
		lerp(current_color.b, next_color.b, transition_timer / transition_duration)
	)
	
	set_color(lerp_color)
