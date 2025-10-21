extends Node2D

# Dictionary mapping ingredient names to their textures and scales
var INGREDIENT_DATA = {
	"Coffee": {
		"texture": preload("res://assets/Coffee.png"),
		"scale": Vector2(0.05, 0.05),
		"collision_shape": CapsuleShape2D.new(),
		"collision_radius": 82.0,
		"collision_height": 164.0,
		"collision_offset": Vector2(0, 4)
	},
	"Matcha": {
		"texture": preload("res://assets/Matcha.png"),
		"scale": Vector2(0.05, 0.05),
		"collision_shape": CapsuleShape2D.new(),
		"collision_radius": 82.0,
		"collision_height": 164.0,
		"collision_offset": Vector2(0, 1)
	},
	"Honey": {
		"texture": preload("res://assets/Honey.png"),
		"scale": Vector2(0.05, 0.05),
		"collision_shape": CapsuleShape2D.new(),
		"collision_radius": 57.0,
		"collision_height": 144.0,
		"collision_offset": Vector2(0, 15)
	},
	"Milk": {
		"texture": preload("res://assets/Milk.png"),
		"scale": Vector2(0.04, 0.05),
		"collision_shape": CapsuleShape2D.new(),
		"collision_radius": 60.0,
		"collision_height": 170.0,
		"collision_offset": Vector2(0, 0)
	},
	"Whip": {
		"texture": preload("res://assets/Whip.png"),
		"scale": Vector2(0.07, 0.07),
		"collision_shape": CapsuleShape2D.new(),
		"collision_radius": 43.0,
		"collision_height": 196.0,
		"collision_offset": Vector2(1, 61)
	},
	"Sprinkles": {
		"texture": preload("res://assets/Sprinkles.png"),
		"scale": Vector2(0.04, 0.04),
		"collision_shape": CapsuleShape2D.new(),
		"collision_radius": 35.0,
		"collision_height": 130.0,
		"collision_offset": Vector2(0, 0)
	}
}

@export var ingredient_scene: PackedScene = preload("res://scenes/ingredient.tscn")
@export var shelf_width: float = 800.0  # Width of the shelf area
@export var shelf_y_position: float = 140.0  # Y position of ingredients
@export var min_spacing: float = 120.0  # Minimum space between ingredients

var unlocked_ingredients: Array[String] = ["Coffee", "Matcha"]  # Start with these
var ingredient_nodes: Dictionary = {}

func _ready() -> void:
	# Setup collision shapes for each ingredient type
	for ingredient_name in INGREDIENT_DATA:
		var data = INGREDIENT_DATA[ingredient_name]
		var shape = data["collision_shape"] as CapsuleShape2D
		shape.radius = data["collision_radius"]
		shape.height = data["collision_height"]
	
	# Create initial ingredients
	_update_shelf()

func unlock_ingredient(ingredient_name: String) -> void:
	if ingredient_name in INGREDIENT_DATA and ingredient_name not in unlocked_ingredients:
		unlocked_ingredients.append(ingredient_name)
		_update_shelf()

func _update_shelf() -> void:
	# Clear existing ingredient nodes
	for node in ingredient_nodes.values():
		node.queue_free()
	ingredient_nodes.clear()
	
	# Calculate spacing
	var num_ingredients = unlocked_ingredients.size()
	if num_ingredients == 0:
		return
	
	# Calculate dynamic spacing
	var total_spacing = shelf_width - (min_spacing * 0.5)  # Account for edge margins
	var spacing = min(min_spacing, total_spacing / num_ingredients)
	
	# Calculate starting X position to center the ingredients
	var total_width = spacing * (num_ingredients - 1) if num_ingredients > 1 else 0
	var start_x = (shelf_width - total_width) / 2
	
	# Create ingredient nodes
	for i in range(num_ingredients):
		var ingredient_name = unlocked_ingredients[i]
		var data = INGREDIENT_DATA[ingredient_name]
		
		# Instantiate ingredient
		var ingredient_instance = ingredient_scene.instantiate()
		ingredient_instance.name = ingredient_name
		
		# Set position
		var x_pos = start_x + (i * spacing)
		ingredient_instance.position = Vector2(x_pos, shelf_y_position)
		
		# Configure sprite
		var sprite = ingredient_instance.get_node("Sprite2D") as Sprite2D
		sprite.texture = data["texture"]
		sprite.scale = data["scale"]
		
		# Configure collision shape
		var collision_shape = ingredient_instance.get_node("CollisionShape2D") as CollisionShape2D
		collision_shape.shape = data["collision_shape"]
		collision_shape.position = data["collision_offset"]
		collision_shape.visible = false
		
		# Add to scene
		add_child(ingredient_instance)
		ingredient_nodes[ingredient_name] = ingredient_instance

