extends Control

var master_bus = AudioServer.get_bus_index("Master")


func _on_FullscreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus,value)

	if value == -30:
		AudioServer.set_bus_mute(master_bus,true)
	else:
		AudioServer.set_bus_mute(master_bus,false)


func _on_ReturnButton_mouse_entered():
	get_parent().get_node("MainMenu/Hover").play()


func _on_ReturnButton_pressed():
	get_parent().get_node("MainMenu/Press").play()
	$".".visible = false
	get_parent().get_node("MainMenu").visible = true
