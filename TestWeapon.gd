extends StaticBody2D

var smoothing := Vector2()

func _process(delta) -> void:
	smoothing = lerp(smoothing, get_global_mouse_position(), 0.5)
	$".".look_at(smoothing)
