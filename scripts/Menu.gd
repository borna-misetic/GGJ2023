extends Control

onready var animation_player = get_parent().get_node("AnimationPlayer")

var max_menu_travel := 10

var menu_center_position := Vector2.ZERO

func _ready():
	animation_player.play("fade_in")
	yield(animation_player,"animation_finished")
	var rect = get_viewport_rect()
	menu_center_position = rect_position + (rect.size/2)

func _process(delta) -> void:
	# lerp menu
	var mouse_from_center = ((get_global_mouse_position() - menu_center_position)*-1).limit_length(max_menu_travel)
	rect_global_position = lerp(rect_global_position,mouse_from_center,delta*3)


func _on_QuitButton_mouse_entered():
	$Hover.play()



func _on_OptionsButton_mouse_entered():
	$Hover.play()


func _on_PlayButton_mouse_entered():
	$Hover.play()

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_OptionsButton_pressed():
	$Press.play()
	get_parent().get_node("MainMenu").visible = false
	get_parent().get_node("OptionScreen").visible = true


func _on_PlayButton_pressed():
	$Press.play()
	animation_player.play("fade_out")
	yield(animation_player,"animation_finished")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Cutscene.tscn")

