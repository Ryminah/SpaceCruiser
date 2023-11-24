extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%ScoreEnd.text = str(Global.score)
	%TempsEnd.text = str("%.0f" % Global.temps)
	%TopScore.text = str(Global.bestScore)
	if Global.score > Global.bestScore:
		Global.bestScore = Global.score
		


func _on_menu_pressed():
	Global.score = 0
	Global.temps = 0
	Global.boost = 0
	get_tree().change_scene_to_file("res://Menus/menu.tscn")
