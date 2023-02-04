extends Control


var max_menu_travel := 30

var menu_center_position := Vector2.ZERO

func _ready():
	var rect = get_viewport_rect()
	menu_center_position = rect_position + (rect.size/2)
	$HeadUpgradeLabel.text = ("SHOVEL HEAD: " + str(PlayerState.HEAD_LEVEL) + "/5")
	
func _process(delta) -> void:
	# lerp menu
	var mouse_from_center = ((get_global_mouse_position() - menu_center_position)*-1).limit_length(max_menu_travel)
	rect_global_position = lerp(rect_global_position,mouse_from_center,delta*3)



func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_HeadUpgradeButton_pressed():
	if(PlayerState.HEAD_LEVEL < 5):
		PlayerState.HEAD_LEVEL += 1
		$HeadUpgradeLabel.text = ("SHOVEL HEAD: " + str(PlayerState.HEAD_LEVEL) + "/5")


func _on_HandleUpgradeButton_pressed():
	if(PlayerState.HANDLE_LEVEL < 5):
		PlayerState.HANDLE_LEVEL += 1
		$HandleUpgradeLabel.text = ("SHOVEL HANDLE: " + str(PlayerState.HANDLE_LEVEL) + "/5")
