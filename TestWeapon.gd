extends StaticBody2D

var tip6 = preload("res://assets/shovels/shovelH5.png")

var smoothing := Vector2()
var mouse_pos := Vector2()

func _process(delta) -> void:
	if(get_viewport().size.x/2>mouse_pos.x):
		$".".scale.y = -1
	if(get_viewport().size.x/2<mouse_pos.x):
		$".".scale.y = 1
	mouse_pos = get_global_mouse_position()
	smoothing = lerp(smoothing, mouse_pos, 0.5)
	$".".look_at(smoothing)
	$Hands/Tip.texture = tip6
	print(mouse_pos)
