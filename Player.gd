extends KinematicBody2D

export var noise_shake_speed := 30.0
export var noise_shake_strength := 30.0
export var speed := 300
export var jump := -300
export var gravity := 9.81

onready var noise = OpenSimplexNoise.new()
onready var animation = $AnimationPlayer

var noise_i := 0.0
var shake_strength := 0.0
var velocity := Vector2()

func _physics_process(delta) -> void:
	velocity.y += gravity
	if Input.is_action_pressed("move_left"):
		animation.play("walk")
		velocity.x = -speed
		$Sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
		animation.play("walk")
		$Sprite.flip_h = false
	else:
		velocity.x = 0
		animation.play("idle")
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump
	if Input.is_action_just_pressed("dig") and $Weapon/RayCast2D.get_collider():
		if $Weapon/RayCast2D.get_collider().is_in_group("diggable"):
			$Weapon/RayCast2D.get_collider().queue_free()
			print("digging")
	velocity = move_and_slide(velocity,Vector2.UP)



# will be used later for screenshake
func get_noise_offset(delta):
	noise_i += delta * noise_shake_speed
	return Vector2(
		noise.get_noise_2d(1,noise_i) * noise_shake_strength,
		noise.get_noise_2d(100,noise_i) * noise_shake_strength
	)
