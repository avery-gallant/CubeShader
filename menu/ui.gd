extends Control
signal ThresholdChanged
@onready
var cEdit = $VBoxContainer/CurveEdit
# Called when the node enters the scene tree for the first time.

func init(redCurve,greenCurve,blueCurve):
	cEdit.init([redCurve,greenCurve,blueCurve])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		var pressed = $VBoxContainer/RefreshToggle/MarginContainer/VBoxContainer/CheckBox.button_pressed
		$VBoxContainer/RefreshToggle/MarginContainer/VBoxContainer/CheckBox.button_pressed = !pressed


func _on_edit_pressed() -> void:
	$VBoxContainer/ColorOpen.hide()
	$VBoxContainer/LightToggle.hide()
	cEdit.display()


func _on_curve_edit_close() -> void:
	$VBoxContainer/ColorOpen.show()
	$VBoxContainer/LightToggle.show()
	cEdit.closeDisplay()

func close():
	$VBoxContainer/ColorOpen.show()
	$VBoxContainer/LightToggle.show()
	cEdit.closeDisplay()
	visible = false
func open(redCurve,greenCurve,blueCurve):
	visible = true
	cEdit.init([redCurve,greenCurve,blueCurve])


func _on_h_slider_value_changed(value: float) -> void:
	ThresholdChanged.emit(value)
