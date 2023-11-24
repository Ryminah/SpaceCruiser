extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	_resume()
	
func _resume():
	hide()
	get_tree().paused = false


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/menu.tscn")
	_resume()
