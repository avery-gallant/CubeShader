extends Control
var curveColors = [Color.RED,Color.GREEN,Color.BLUE]
var curves = []
@onready
var editor =$MarginContainer/MarginContainer2/VBoxContainer/MarginContainer/Editor
@onready
var colorBar = $MarginContainer/MarginContainer2/VBoxContainer/colorBar
signal close
func init(curvesIn:Array):
	editor.init(curvesIn)
	colorBar.curves = curvesIn
	colorBar.initialized = true
	colorBar.queue_redraw()
	
func display():
	editor.display()
	visible = true
	
func closeDisplay():
	visible = false
	editor.close()
	
func _on_red_pressed() -> void:
	editor.editCurve(0)

func _on_green_pressed() -> void:
	editor.editCurve(1)

func _on_blue_pressed() -> void:
	editor.editCurve(2)


func _on_close_pressed() -> void:
	emit_signal("close")
