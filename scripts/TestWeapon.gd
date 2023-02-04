extends StaticBody2D

onready var head = $Hands/Head
onready var handle = $Hands/Handle

var smoothing := Vector2()
var mouse_pos := Vector2()

func _ready():
	match(PlayerState.HEAD_LEVEL):
		1:
			head.texture = load("res://assets/shovels/shovelH1.png")
		2:
			head.texture = load("res://assets/shovels/shovelH2.png")
		3:
			head.texture = load("res://assets/shovels/shovelH3.png")
		4:
			head.texture = load("res://assets/shovels/shovelH4.png")
		5:
			head.texture = load("res://assets/shovels/shovelH5.png")
	match(PlayerState.HANDLE_LEVEL):
		1:
			handle.texture = load("res://assets/shovels/shovelHA1.png")
			PlayerState.SHOVEL_STRENGTH = 20
		2:
			handle.texture = load("res://assets/shovels/shovelHA2.png")
			PlayerState.SHOVEL_STRENGTH = 40
		3:
			handle.texture = load("res://assets/shovels/shovelHA3.png")
			PlayerState.SHOVEL_STRENGTH = 60
		4:
			handle.texture = load("res://assets/shovels/shovelHA4.png")
			PlayerState.SHOVEL_STRENGTH = 80
		5:
			handle.texture = load("res://assets/shovels/shovelHA5.png")
			PlayerState.SHOVEL_STRENGTH = 100

func _process(_delta) -> void:
	mouse_pos = get_global_mouse_position()
	smoothing = lerp(smoothing, mouse_pos, 0.5)
	$".".look_at(smoothing)
