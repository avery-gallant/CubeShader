extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MeshInstance3D.mesh.material.set_shader_parameter("viewport_texture", $SubViewport.get_texture())
	$UI.init($SubViewport/Background.redCurve,$SubViewport/Background.greenCurve,$SubViewport/Background.blueCurve)
	$UI/VBoxContainer/LightToggle/MarginContainer/VBoxContainer/CheckBox.connect("toggled", toggle_light)
	$UI/VBoxContainer/RefreshToggle/MarginContainer/VBoxContainer/CheckBox.connect("toggled", $SubViewport/Background.toggleRedraw)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		if $UI.visible:
			$UI.close()
		elif !$UI.visible:
			$UI.open($SubViewport/Background.redCurve,$SubViewport/Background.greenCurve,$SubViewport/Background.blueCurve)
	if Input.is_action_pressed("Left"):
		$Cube.position.x-=0.03
	if Input.is_action_pressed("Right"):
		$Cube.position.x+=0.03
	if Input.is_action_pressed("Forth"):
		$Cube.position.z-=0.03
	if Input.is_action_pressed("Back"):
		$Cube.position.z+=0.03
	
	
	if Input.is_action_pressed("LightForth"):
		$Pivot/SpotLight3D.position.x+=0.1
	if Input.is_action_pressed("LightBack"):
		$Pivot/SpotLight3D.position.x-=0.1
	$Pivot/SpotLight3D.position.x=clampf($Pivot/SpotLight3D.position.x,0.0,40.0)
	if Input.is_action_pressed("RotArndUp"):
		$Pivot.rotate_y(PI/100)
	if Input.is_action_pressed("RotArndDn"):
		$Pivot.rotate_y(-PI/100)

func toggle_light(on):
	$Pivot/Line.visible = on
	$Pivot/SpotLight3D/Ball.visible = on
