extends Control


var max_menu_travel := 30

var menu_center_position := Vector2.ZERO

var handle_prices = [100, 250, 500, 1500, "MAX"]
var head_prices = [100, 250, 500, 1500, "MAX"]

func _ready():
	var rect = get_viewport_rect()
	menu_center_position = rect_position + (rect.size/2)
	$HeadUpgradeLabel.text = ("SHOVEL HEAD: " + str(PlayerState.HEAD_LEVEL) + "/5")
	$HandleUpgradeLabel.text = ("SHOVEL HANDLE: " + str(PlayerState.HANDLE_LEVEL) + "/5")
	$ResourcesLabel.text = ("RESOURCES LEFT: " + str(PlayerState.EARNED_RESOURCES))
	$HeadUpgradePrice.text = ("PRICE: " + str(head_prices[PlayerState.HEAD_LEVEL-1]))
	$HandleUpgradePrice.text = ("PRICE: " + str(handle_prices[PlayerState.HANDLE_LEVEL-1]))
	if(PlayerState.HANDLE_LEVEL == 5):
		$HandleUpgradeButton.disabled = true
	if(PlayerState.HEAD_LEVEL == 5):
		$HeadUpgradeButton.disabled = true
	
func _process(delta) -> void:
	# lerp menu
	var mouse_from_center = ((get_global_mouse_position() - menu_center_position)*-1).limit_length(max_menu_travel)
	rect_global_position = lerp(rect_global_position,mouse_from_center,delta*3)



func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_HeadUpgradeButton_pressed():
	if(PlayerState.HEAD_LEVEL < 5 and (PlayerState.EARNED_RESOURCES - handle_prices[PlayerState.HEAD_LEVEL-1]) >= 0):
		$Buy.play()
		PlayerState.HEAD_LEVEL += 1
		PlayerState.EARNED_RESOURCES -= head_prices[PlayerState.HEAD_LEVEL - 2]
		$HeadUpgradeLabel.text = ("SHOVEL HEAD: " + str(PlayerState.HEAD_LEVEL) + "/5")
		$HeadUpgradePrice.text = ("PRICE: " + str(head_prices[PlayerState.HEAD_LEVEL-1]))
		$ResourcesLabel.text = ("RESOURCES LEFT: " + str(PlayerState.EARNED_RESOURCES))
	if(PlayerState.HEAD_LEVEL == 5):
		$HeadUpgradeButton.disabled = true

func _on_HandleUpgradeButton_pressed():
	if(PlayerState.HANDLE_LEVEL < 5 and (PlayerState.EARNED_RESOURCES - handle_prices[PlayerState.HANDLE_LEVEL-1]) >= 0):
		$Buy.play()
		PlayerState.HANDLE_LEVEL += 1
		PlayerState.EARNED_RESOURCES -= handle_prices[PlayerState.HANDLE_LEVEL - 2]
		$HandleUpgradeLabel.text = ("SHOVEL HANDLE: " + str(PlayerState.HANDLE_LEVEL) + "/5")
		$HandleUpgradePrice.text = ("PRICE: " + str(handle_prices[PlayerState.HANDLE_LEVEL-1]))
		$ResourcesLabel.text = ("RESOURCES LEFT: " + str(PlayerState.EARNED_RESOURCES))
	if(PlayerState.HANDLE_LEVEL == 5):
		$HandleUpgradeButton.disabled = true


func _on_PlayButton_mouse_entered():
	$Hover.play()


func _on_HeadUpgradeButton_mouse_entered():
	$Hover.play()


func _on_HandleUpgradeButton_mouse_entered():
	$Hover.play()
