extends Control
var initialized = false
var curves = []

func _draw():
	if initialized:
		var gradRes = 100
		for i in range(gradRes):
			var iF = float(i)
			var r = curves[0].sample_baked(iF/gradRes)
			var g = curves[1].sample_baked(iF/gradRes)
			var b = curves[2].sample_baked(iF/gradRes)
			draw_line(Vector2(iF/gradRes*size.x,size.y/2),Vector2((iF+1)/gradRes*size.x,size.y/2),Color(r,g,b),size.y)


func _on_editor_updated() -> void:
	queue_redraw()
