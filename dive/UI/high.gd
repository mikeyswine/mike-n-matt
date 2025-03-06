extends CanvasModulate
var red:int
var blu:int
var grn: int
var red_mod = 0.01
var blu_mod = 0.01
var grn_mod = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	red = randf_range(0,1)
	blu = randf_range(0,1)
	grn = randf_range(0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_color_step(red, red_mod, delta)
	handle_color_step(blu, blu_mod, delta)
	handle_color_step(grn, grn_mod, delta)
	color = Color(red,blu,grn,1.0)

func handle_color_step(acolor, astep,delta):
	acolor += astep*delta
	if acolor >=1:
		acolor = 1
		astep = -0.01
	if acolor <= 0:
		acolor = 0
		astep = 0.01
