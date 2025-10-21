extends Area2D

var BASE_COLORS = {
	"Empty": Color(0.701, 0.686, 0.677),
	"Coffee": Color(0.2, 0.1, 0.05),
	"Matcha": Color(0.1, 0.3, 0.1),
	"CoffeeMilk": Color(0.6, 0.5, 0.4),
	"MatchaMilk": Color(0.3, 0.5, 0.3),
	"CoffeeMilkHoney": Color(0.4, 0.3, 0.2),
	"MatchaMilkHoney": Color(0.3, 0.5, 0.3),
}

var RECIPES = load("res://data/recipes.json").data

var ingredients = []
var ingredient_being_added = null
var current_color = BASE_COLORS["Empty"]

var color_rect

signal recipe_discovered(beverage: String)

func _ready() -> void:
	color_rect = find_child("Base")
	
func _process(delta: float) -> void:
	var clear = find_child("Clear")
	if (ingredients == []): clear.hide()
	else: clear.show()
	
func _on_area_entered(area):
	if area.get_script() and area.get_script().get_path().ends_with("ingredient.gd"):
		ingredient_being_added = str(area.name)
		print("Ingredient is being dragged into beverage: ", area.name)

func _on_area_exited(area):
	if area.get_script() and area.get_script().get_path().ends_with("ingredient.gd"):
		if area.dragging:
			ingredient_being_added = null
			print("Ingredient left beverage area: ", area.name)

func _compare_arrays(arr1, arr2):
	if arr1.size() != arr2.size(): return false
	for item in arr1:
		if !arr2.has(item): return false
		if arr1.count(item)!= arr2.count(item): return false
	return true

func _set_beverage():
	var label = find_child("Label")
	for recipe in RECIPES.values():
		if (_compare_arrays(recipe, ingredients)):
			var beverage = RECIPES.find_key(recipe)
			label.text = beverage
			# UPDATE: to on submit?
			recipe_discovered.emit(beverage)
			return
	label.text = ''

func _set_color(color: Color) -> void:
	current_color = color
	for child in color_rect.get_children():
		child.color = color

func _add_honey_tint(base_color: Color) -> Color:
	var honey_tint = Color(0.9, 0.7, 0.3)  
	return base_color.lerp(honey_tint, 0.3)  # Blend 30% honey tint with base color

func _add_ingredient(ingredient_name: String) -> void:
	if (!ingredients.has(ingredient_name)): ingredients.append(ingredient_name)
	print("Ingredient was placed in beverage: ", ingredient_name)

	# Base ingredients
	if ingredient_name == "Coffee":
		if (ingredients.has("Matcha")): ingredients.erase("Matcha")
		
		if (ingredients.has("Milk")): _set_color(BASE_COLORS["CoffeeMilk"])
		else: _set_color(BASE_COLORS["Coffee"])
	elif ingredient_name == "Matcha":
		if (ingredients.has("Coffee")): ingredients.erase("Coffee")

		if (ingredients.has("Milk")): _set_color(BASE_COLORS["MatchaMilk"])
		else: _set_color(BASE_COLORS["Matcha"])
	
	# Toppings
	if ingredient_name == "Honey":
		_set_color(_add_honey_tint(current_color))
	elif ingredient_name == "Milk":
		if (ingredients.has("Coffee")): _set_color(BASE_COLORS["CoffeeMilk"])  # Lighter latte brown (coffee + milk)
		elif (ingredients.has("Matcha")): _set_color(BASE_COLORS["MatchaMilk"])  # Matcha latte green (matcha + milk)
		else: _set_color(Color.WHITE)
	elif ingredient_name == "Whip":
		if (ingredients.has("Sprinkles")):
			var sprinkles = find_child("Sprinkles")
			sprinkles.hide()
			var sprinkles_with_whip = find_child("Whip and Sprinkles")
			sprinkles_with_whip.visible = true
		var whip = find_child("Whip")
		whip.visible = true
	elif ingredient_name == "Sprinkles":
		if (ingredients.has("Whip")):
			var whip = find_child("Whip and Sprinkles")
			whip.visible = true
		else:
			var sprinkles = find_child("Sprinkles")
			sprinkles.visible = true
	
	ingredient_being_added = null
	print("Ingredients in beverage: ", ingredients)

func _input(event: InputEvent) -> void:
	# If the mouse button is released and the ingredient is being added, add the ingredient to the beverage
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and ingredient_being_added:
			_add_ingredient(ingredient_being_added)
			_set_beverage()

func _on_clear_pressed() -> void:
	ingredients = []
	_set_beverage()
	_set_color(BASE_COLORS["Empty"])
	var whip = find_child("Whip")
	whip.visible = false
	var whip_and_sprinkles = find_child("Whip and Sprinkles")
	whip_and_sprinkles.visible = false
	var sprinkles = find_child("Sprinkles")
	sprinkles.visible = false
