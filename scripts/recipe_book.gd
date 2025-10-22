extends Area2D

var raw_recipes = load("res://data/recipes.json")
var RECIPES
var recipe_node

var discovered = []
var current = 0

func _ready() -> void:
	RECIPES = raw_recipes.data
	recipe_node = find_child("Recipe")
	var beverage_node = get_node("../Beverage")
	beverage_node.connect("recipe_discovered", _on_recipe_discovered)	
	_set_recipe()

func _parse_ingredients(list: Array):
	var result = ''
	for ingredient in list:
		result += '- ' + ingredient + '\n'
	return result

func _update_button_visibility():
	if discovered.size() <= 1:
		find_child("Next").hide()
		find_child("Previous").hide()
	else:		
		if current >= discovered.size() - 1:
			find_child("Next").hide()
		else:
			find_child("Next").show()
		
		if current <= 0:
			find_child("Previous").hide()
		else:
			find_child("Previous").show()

func _set_recipe():
	if discovered.size() == 0: return
	var title = discovered[current]
	var list = RECIPES.get(title)
	recipe_node.find_child("Title").text = title
	recipe_node.find_child("List").text = _parse_ingredients(list)
	if (discovered.size() >= 1): find_child("Number").show()
	find_child("Number").text = str(current + 1) + " / " + str(RECIPES.size())
	_update_button_visibility()

func _on_previous_pressed() -> void:
	if current > 0:
		current -= 1
		_set_recipe()

func _on_next_pressed() -> void:
	if current < discovered.size() - 1:
		current += 1
		_set_recipe()
		
func _on_recipe_discovered(title: String):
	print("Discovered: ", title)
	if !discovered.has(title): discovered.append(title)
	current = discovered.size() - 1
	_set_recipe()
