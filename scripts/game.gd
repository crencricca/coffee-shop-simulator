extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_recipes_button_pressed() -> void:
	find_child("Overlay").show()
	find_child("Recipe Book").show()


func _on_close_recipe_pressed() -> void:
	find_child("Overlay").hide()
	find_child("Recipe Book").hide()
