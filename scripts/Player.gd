extends KinematicBody2D


export var speed := 300
export var jump := -300
export var gravity := 9.81
export var random_shake_strength := 5.0
export var shake_decay_rate := 10.0

onready var camera = $Camera2D
onready var rand = RandomNumberGenerator.new()
onready var animation = $AnimationPlayer
onready var weapon_position : Vector2 = $Weapon.position
onready var swing_timer = $SwingTimer
onready var transition_animation = get_parent().get_node("AnimationPlayer")
onready var tween = get_node("Weapon/Tween")

const indicator = preload("res://scenes/DamageIndicator.tscn")

var swing_speeds = [1.6, 1.1, 0.75, 0.4, 0.2]

var shake_strength := 0.0
var velocity := Vector2()
var damage_number := 0

func apply_shake():
	shake_strength = random_shake_strength

func _ready():
	PlayerState.boss_phase = false
	rand.randomize()
	$RoundTimer.start(180)
	swing_timer.start(swing_speeds[PlayerState.HANDLE_LEVEL-1])
	$CanvasLayer/Control/LabelAnimation.play("Spin")


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
	
	if velocity.x != 0 and is_on_floor():
		if $WalkTimer.time_left <= 0:
			$WalkSound.pitch_scale = rand_range(0.7,0.8)
			$WalkSound.play()
			$WalkTimer.start(0.2)
	if is_on_floor():
		if (Input.is_action_just_pressed("jump")):
			velocity.y = jump
		elif Input.is_action_pressed("down"):
			set_collision_mask_bit(1, false)
			
	# swing
	if Input.is_action_just_pressed("dig") and swing_timer.time_left <= 0:
		$SwooshSound.play()
		calculate_damage()
		swing_timer.start(swing_speeds[PlayerState.HANDLE_LEVEL-1])
		if $Weapon/RayCast2D.get_collider() and $Weapon/RayCast2D.get_collider().is_in_group("diggable"):
			apply_shake()
			get_node($Weapon/RayCast2D.get_collider().get_path()).health -= damage_number
			spawn_damage(damage_number)
			$DigSound.play()
			

	velocity = move_and_slide(velocity,Vector2.UP)


func _process(delta):
	shake_strength = lerp(shake_strength,0,shake_decay_rate*delta)
	camera.offset = get_random_offset()
	if PlayerState.boss_phase == false:
		$CanvasLayer/Control/TimeLabel.text = "%d:%02d" % [floor($RoundTimer.time_left / 60), int($RoundTimer.time_left) % 60]
	elif PlayerState.boss_phase == true:
		$CanvasLayer/Control/TimeLabel.text = "?:??"
	if $RoundTimer.time_left <= 0 and PlayerState.boss_phase == false:
		transition_animation.play("fade_in")
		yield(transition_animation,"animation_finished")
		get_tree().change_scene("res://scenes/Shop.tscn")



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

func spawn_damage(damage: int):
	var indicate = indicator.instance()
	indicate.global_position = global_position
	get_tree().current_scene.add_child(indicate)
	indicate.label.text = str(damage)

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength,shake_strength),
		rand.randf_range(-shake_strength,shake_strength)
	)
