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

func _process(delta: float) -> void:
	if discovered.size() > 1: find_child("Next").show()
	pass

func _parse_ingredients(list: Array):
	var result = ''
	for ingredient in list:
		result += '- ' + ingredient + '\n'
	return result

func _set_recipe():
	if discovered.size() == 0: return
	var title = discovered[current]
	var list = RECIPES.get(title)
	recipe_node.find_child("Title").text = title
	recipe_node.find_child("List").text = _parse_ingredients(list)
	print(_parse_ingredients(list))

func _on_next_pressed()  -> void:
	if (current >= discovered.size() - 1):
		current = 0
		_set_recipe()
	else:
		current += 1
		_set_recipe()
		
func _on_recipe_discovered(title: String):
	print("Discovered: ", title)
	if !discovered.has(title): discovered.append(title)
	current = discovered.size() - 1
	_set_recipe()
