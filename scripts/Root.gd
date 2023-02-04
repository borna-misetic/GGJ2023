extends Area2D
export (Resource) var resource

onready var health = resource.health
onready var resources = resource.resources

var enemy_explosion = preload("res://scenes/BlockExplosion.tscn")

func _process(_delta) -> void:
	if(health <= 0):
		var effect = enemy_explosion.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
		PlayerState.EARNED_RESOURCES += resource.resources
		queue_free()
