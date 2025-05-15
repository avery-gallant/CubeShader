extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	var margin_left = get_theme_constant("margin_left")
	var margin_top = get_theme_constant("margin_top")
	var margin_right = get_theme_constant("margin_right")
	var margin_bottom = get_theme_constant("margin_bottom")
	draw_line(Vector2(margin_left,margin_top), Vector2(size.x-margin_right,margin_top),Color(0.4,0.4,0.4),2)
	draw_line(Vector2(margin_left,margin_top), Vector2(margin_left,size.y-margin_bottom),Color(0.4,0.4,0.4),2)
	draw_line(Vector2(size.x-margin_right,size.y-margin_bottom), Vector2(size.x-margin_right,margin_top),Color(0.4,0.4,0.4),2)
	draw_line(Vector2(size.x-margin_right,size.y-margin_bottom), Vector2(margin_left,size.y-margin_bottom),Color(0.4,0.4,0.4),2)
