extends KinematicBody2D

export var noise_shake_speed := 30.0
export var noise_shake_strength := 30.0
export var speed := 300
export var jump := -300
export var gravity := 9.81

onready var noise = OpenSimplexNoise.new()
onready var animation = $AnimationPlayer
onready var weapon_position : Vector2 = $Weapon.position
onready var swing_timer = $SwingTimer
onready var transition_animation = get_parent().get_node("AnimationPlayer")

var swing_speeds = [1.6, 1.1, 0.75, 0.4, 0.2]

var noise_i := 0.0
var shake_strength := 0.0
var velocity := Vector2()
var damage_number := 0

func _ready():
	$AnimationPlayer.play("fade_out")
	$RoundTimer.start(5)
	swing_timer.start(PlayerState.SWING_TIME)
	$CanvasLayer/Control/LabelAnimation.play("Spin")

func apply_shake() -> void:
	shake_strength = noise_shake_strength

func _physics_process(_delta) -> void:
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
	
	if velocity.x != 0 and is_on_floor():
		if $WalkTimer.time_left <= 0:
			$WalkSound.pitch_scale = rand_range(0.7,0.8)
			$WalkSound.play()
			$WalkTimer.start(0.2)
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump
			
	# swing
	if Input.is_action_just_pressed("dig") and swing_timer.time_left <= 0:
		$SwooshSound.play()
		calculate_damage()
		swing_timer.start(swing_speeds[PlayerState.HANDLE_LEVEL-1])
		if $Weapon/RayCast2D.get_collider() and $Weapon/RayCast2D.get_collider().is_in_group("diggable"):
			get_node($Weapon/RayCast2D.get_collider().get_path()).health -= damage_number
			print(damage_number)
			$DigSound.play()
	velocity = move_and_slide(velocity,Vector2.UP)


func _process(_delta):
	$CanvasLayer/Control/TimeLabel.text = "%d:%02d" % [floor($RoundTimer.time_left / 60), int($RoundTimer.time_left) % 60]
	if $RoundTimer.time_left <= 0:
		transition_animation.play("fade_in")
		yield(transition_animation,"animation_finished")
		get_tree().change_scene("res://scenes/Shop.tscn")


# will be used later for screenshake
func get_noise_offset(delta):
	noise_i += delta * noise_shake_speed
	return Vector2(
		noise.get_noise_2d(1,noise_i) * shake_strength,
		noise.get_noise_2d(100,noise_i) * shake_strength
	)

func calculate_damage():
	match(PlayerState.HEAD_LEVEL):
		1:
			damage_number = int(rand_range(10,20))
		2:
			damage_number = int(rand_range(40,60))
		3:
			damage_number = int(rand_range(80,90))
		4:
			damage_number = int(rand_range(110,125))
		5:
			damage_number = int(rand_range(130,160))
