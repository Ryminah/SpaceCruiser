extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%Score.text = str(Global.score)
	%Temps.text = str("%.0f" % Global.temps)



func _on_start_button_pressed():
	Global.score = 0
	Global.temps = 0
	Global.boost = 0
	get_tree().change_scene_to_file(Global.current_circuit)


func _on_menu_pressed():
	Global.score = 0
	Global.temps = 0
	Global.boost = 0
	get_tree().change_scene_to_file("res://Menus/menu.tscn")
