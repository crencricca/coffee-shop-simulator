extends Area2D

var dragging = false
var original_position: Vector2
signal drag_signal(ingredient_instance)

func _ready():
	connect("drag_signal", _set_dragging)
	original_position = global_position

func _process(_delta: float) -> void:
	if dragging:
		var mousepos = get_global_mouse_position()
		self.position = mousepos
	
func _set_dragging(ingredient_instance):
	if ingredient_instance == self:
		dragging = !dragging

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			var distance = global_position.distance_to(mouse_pos)
			if distance < 50: 
				drag_signal.emit(self)
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and dragging:
			self.position = original_position
			dragging = false
