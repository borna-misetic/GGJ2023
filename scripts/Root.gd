extends Area2D
export (Resource) var resource

onready var health = resource.health

func _process(delta) -> void:
	if(health == 0):
		queue_free()
