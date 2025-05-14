extends Control
var primaryCurve:Curve
var curveColors = [Color.RED,Color.GREEN,Color.BLUE]
var curves = []
var curvePts = []
@onready
var cWin = Vector2(size.x,size.y)
var closePt = -1
var stuck = "none"
var initialized = false
var ptSelect = -1
var open = false
signal updated
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw():
	if initialized:
		var curveRes = 50
		var indices = range(len(curves))
		indices.reverse()
		for i in indices:
			var ptsArr = []
			for j in range(curveRes+1):
				var jF = float(j)
				ptsArr.append(
					mc(Vector2(jF/curveRes,1-curves[i].sample_baked(jF/curveRes)),cWin)
				)
			draw_polyline(PackedVector2Array(ptsArr), curveColors[i],1.0)
		if primaryCurve:
			if (ptSelect!=-1):
				var scaledPt = mc(curvePts[ptSelect],cWin)
				
				var tanA = deg_to_rad(primaryCurve.get_point_right_tangent(ptSelect))
				var tanPtR = Vector2(cos(tanA)*40+scaledPt.x,-sin(tanA)*40+scaledPt.y)
				var tanPtL = Vector2(cos(tanA+PI)*40+scaledPt.x,-sin(tanA+PI)*40+scaledPt.y)
				draw_line(Vector2(tanPtR.x,(tanPtR.y)),Vector2(tanPtL.x,(tanPtL.y)),Color(0,0,0,0.75),4)
				draw_rect(Rect2(tanPtR.x-4,tanPtR.y-4,8,8),Color.BLACK)
				draw_rect(Rect2(tanPtL.x-4,tanPtL.y-4,8,8),Color.BLACK)
			for i in range(len(curvePts)):
				var scaledPt = mc(curvePts[i],cWin)
				if i ==ptSelect:
					draw_circle(scaledPt,4,Color(0.2,0.7,1),false,1)
				else:
					draw_circle(scaledPt,4,Color(0.8,0.8,0.8),false,1)

func _input(event):
	if !open || !initialized || !primaryCurve:
		return
		
	if Input.is_action_just_pressed("remove"):
		if ptSelect!=-1 && len(curvePts)>1:
			primaryCurve.remove_point(ptSelect)
			curvePts.remove_at(ptSelect)
			ptSelect = -1
			queue_redraw()
			emit_signal("updated")
	elif event is InputEventMouseMotion:
		if stuck=="none":
			var curShortestDist = INF
			var curShortestInd=-1
			var mousePos = event.position
			for i in range(primaryCurve.point_count):
				var dist = mousePos.distance_to(mc(curvePts[i],cWin)+global_position)
				if dist < curShortestDist:
					curShortestInd = i
					curShortestDist = dist
			if curShortestDist<10:
				if closePt!=curShortestInd:
					closePt = curShortestInd
					queue_redraw()
			else:
				if closePt!=-1:
					closePt = -1
					queue_redraw()
		elif stuck == "point":
			var newPt=dc(event.position-global_position,cWin)
			newPt.x = clampf(newPt.x,0,1)
			newPt.y = clampf(newPt.y,0,1)
			curvePts[closePt]=newPt
			
			primaryCurve.set_point_value(closePt,1-newPt.y)
			primaryCurve.set_point_offset(closePt,newPt.x)
			
			emit_signal("updated")
			queue_redraw()
		elif stuck == "tangentR":
			var mousePos = event.position
			primaryCurve.set_point_right_tangent(ptSelect,rad_to_deg(-(mc(curvePts[ptSelect],cWin)+global_position).angle_to_point(mousePos)))
			primaryCurve.set_point_left_tangent(ptSelect,rad_to_deg(-(mc(curvePts[ptSelect],cWin)+global_position).angle_to_point(mousePos)))
			emit_signal("updated")
			queue_redraw()
		elif stuck == "tangentL":
			var mousePos = event.position
			primaryCurve.set_point_right_tangent(ptSelect,rad_to_deg(PI-(mc(curvePts[ptSelect],cWin)+global_position).angle_to_point(mousePos)))
			primaryCurve.set_point_left_tangent(ptSelect,rad_to_deg(PI-(mc(curvePts[ptSelect],cWin)+global_position).angle_to_point(mousePos)))
			emit_signal("updated")
			queue_redraw()
	elif event is InputEventMouseButton:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			
			if ptSelect!=-1:
				var scaledPt = mc(curvePts[ptSelect],cWin)+global_position
				
				var tanA = deg_to_rad(primaryCurve.get_point_right_tangent(ptSelect))
				var tanPtR = Vector2(cos(tanA)*40+scaledPt.x,-sin(tanA)*40+scaledPt.y)
				var tanPtL = Vector2(cos(tanA+PI)*40+scaledPt.x,-sin(tanA+PI)*40+scaledPt.y)
				
				Vector2(tanPtL.x,tanPtL.y)
				var mousePos = event.position
				if mousePos.distance_to(tanPtR)<10:
					stuck = "tangentR"
				elif mousePos.distance_to(tanPtL)<10:
					stuck = "tangentL"
					
			if closePt!=-1:
				stuck = "point"
				ptSelect = closePt
				queue_redraw()
			
			if stuck == "none" && event.position:
				if Rect2(global_position,cWin).has_point(event.position):
				#new point
					var newPt=dc(event.position-global_position,cWin)
					newPt.x = clampf(newPt.x,0,1)
					newPt.y = clampf(newPt.y,0,1)
					if newPt.x>curvePts[-1].x:
						curvePts.append(newPt)
						primaryCurve.add_point(Vector2(newPt.x,1-newPt.y))
						emit_signal("updated")
						stuck = "point"
						ptSelect = len(curvePts)-1
						closePt = len(curvePts)-1
					for i in range(len(curvePts)):
						if newPt.x<curvePts[i].x:
							curvePts.insert(i,newPt)
							primaryCurve.add_point(Vector2(newPt.x,1-newPt.y))
							emit_signal("updated")
							stuck = "point"
							ptSelect = i
							closePt=i
							break
					queue_redraw()
			
			
		if !event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			stuck = "none"
			queue_redraw()
			
func mc(vec1,vec2):
	return Vector2(vec1.x*vec2.x,vec1.y*vec2.y)
func dc(vec1,vec2):
	return Vector2(vec1.x/vec2.x,vec1.y/vec2.y)
	
func init(curvesIn:Array):
	for i in range(len(curveColors)):
		curveColors[i].a=0.4
	closePt = -1
	stuck = "none"
	primaryCurve = null
	
	curves = curvesIn
	initialized = true

func display():
	for i in range(len(curveColors)):
		curveColors[i].a=0.4
	closePt = -1
	stuck = "none"
	primaryCurve = null
	ptSelect = -1
	open = true
	
func close():
	open = false

func editCurve(primary):
	for i in range(len(curveColors)):
		curveColors[i].a=0.4
	curveColors[primary].a=1
	primaryCurve = curves[primary]
	curvePts=[]
	ptSelect = -1
	closePt = -1
	stuck = "none"
	for i in range(primaryCurve.point_count):
		var pt = primaryCurve.get_point_position(i)
		curvePts.append(Vector2(pt.x,1-pt.y))
	queue_redraw()
