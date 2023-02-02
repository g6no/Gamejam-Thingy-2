extends KinematicBody2D

var cur_hp = 5
var max_hp = 5

var damaged = false

# Exported Variables
export var move_speed = 150
export var damage = 1
export var attack_rate : float = 0.5
export var attack_distance = 80
export var chase_distance = 400

# Onready Variables
onready var timer = $Timer
onready var damage_timer = $DamageTimer
onready var enemy_to_player = Vector2()
onready var player = get_node("/root/MainRoom/Player")
onready var col_shape = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = attack_rate
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var distance = position.distance_to(player.position)
	enemy_to_player = player.position - position
	enemy_to_player = enemy_to_player.normalized()
	print(col_shape.rotation_degrees)
	print(col_shape.position.y)

	if distance > attack_distance and distance < chase_distance:
		play_enemy_animation()
		move_and_slide(enemy_to_player * move_speed)
	else:
		$AnimatedSprite.stop()

func _on_Timer_timeout():
	if position.distance_to(player.position) <= attack_distance:
		player.take_damage(damage)

func take_damage(damage_to_take):
	if not damaged:
		print("Enemy took ", damage_to_take, " damage!")
		damage_timer.start()
		damaged = true
		yield(damage_timer, "timeout")
		damaged = false
		print("Damage timer ended!")
		cur_hp -= damage_to_take

		if cur_hp <= 0:
			die()

func play_enemy_animation():
	if enemy_to_player.x >= 0.5:
		if col_shape.rotation_degrees != 90 and col_shape.position.y != 8:
			col_shape.rotation_degrees = 90
			col_shape.position.y = 8
		$AnimatedSprite.play("right")
	elif enemy_to_player.x < -0.5:
		if col_shape.rotation_degrees != 90 and col_shape.position.y != 8:
			col_shape.rotation_degrees = 90
			col_shape.position.y = 8
		$AnimatedSprite.play("left")
	elif enemy_to_player.y > 0.5:
		if col_shape.rotation_degrees == 90 and col_shape.position.y == 8:
			col_shape.rotation_degrees = 0
			col_shape.position.y = 1
		$AnimatedSprite.play("down")
	elif enemy_to_player.y < -0.5:
		if col_shape.rotation_degrees == 90 and col_shape.position.y == 8:
			col_shape.rotation_degrees = 0
			col_shape.position.y = 1
		$AnimatedSprite.play("up")


func die():
	#player.give_xp(xp_to_give)
	print("Enemy died!")
	queue_free()
