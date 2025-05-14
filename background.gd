extends Node2D
var redCurve:Curve = preload("res://red.tres")
var greenCurve:Curve = preload("res://green.tres")
var blueCurve:Curve = preload("res://blue.tres")
var doDraw = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if doDraw:
		queue_redraw()

func _draw():
	for i in range(100):
		var randAng=randf_range(0,2*PI)
		var randX = randi_range(0,2880)
		var randY = randi_range(0,1620)
		var randC = randf_range(0,1)
		var randR = redCurve.sample_baked(randC)
		var randG = greenCurve.sample_baked(randC)
		var randB = blueCurve.sample_baked(randC)
		var randW = randi_range(100,300)
		var randHt= randi_range(10,150)
		
		draw_set_transform(Vector2(randX-randW/2,randY-randHt/2),randAng)
		draw_rect(Rect2(0, 0, randW, randHt), Color(randR,randG,randB))
		
func _on_timer_timeout() -> void:
	doDraw = false

func toggleRedraw(on):
	doDraw = on
