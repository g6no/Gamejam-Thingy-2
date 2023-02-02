extends KinematicBody2D

var cur_hp = 100
var max_hp = 100
var gold = 0
var cur_level = 0
var cur_xp = 0

var vel = Vector2()
var facing_dir = Vector2()

var is_attacking : bool = false
var cannot_attack : bool = false


#Exported variables
export var move_speed = 250
export var damage = 10
export var interact_dist = 70

#onready variables
onready var ray_cast = $RayCast2D
onready var anim = $AnimatedSprite
onready var attack_timer = $AttackAnimationTimer
#onready var ui = get_node("/root/MainScene/CanvasLayer/UI")

func _physics_process(delta):
	#Reset velocity
	vel = Vector2()

	if Input.is_action_pressed("ui_right"):
		vel.x += 1
		facing_dir = Vector2(1,0)
	if Input.is_action_pressed("ui_left"):
		vel.x -= 1
		facing_dir = Vector2(-1,0)
	if Input.is_action_pressed("ui_down"):
		vel.y += 1
		facing_dir = Vector2(0,1)
	if Input.is_action_pressed("ui_up"):
		vel.y -= 1
		facing_dir = Vector2(0,-1)
	if Input.is_action_pressed("attack"):
		is_attacking = true
		play_attack(facing_dir)
		attack()
	
	vel = vel.normalized()
	move_and_slide(vel*move_speed, Vector2.ZERO)
	if not is_attacking:
		manage_animations()

func manage_animations():
	if vel.x > 0:
		play_animation("move_right")
		anim.flip_h = false
	elif vel.x < 0:
		play_animation("move_right")
		anim.flip_h = true
	elif vel.y > 0:
		play_animation("move_down")
	elif vel.y < 0:
		play_animation("move_up")
	elif facing_dir.x == 1:
		play_animation("idle_right")
		anim.flip_h = false
	elif facing_dir.x == -1:
		play_animation("idle_right")
		anim.flip_h = true
	elif facing_dir.y == 1:
		play_animation("idle_down")
	elif facing_dir.y == -1:
		play_animation("idle_up")
			

func play_attack(facing_dir):
	if not cannot_attack:
		if facing_dir.x == 1:
			play_animation("attack_right")
			anim.flip_h = false
			yield(anim, "animation_finished")
			play_animation("idle_right")
		elif facing_dir.x == -1:
			play_animation("attack_right")
			anim.flip_h = true
			yield(anim, "animation_finished")
			play_animation("idle_right")
		elif facing_dir.y == 1:
			play_animation("attack_down")
			yield(anim, "animation_finished")
			play_animation("idle_down")
		elif facing_dir.y == -1:
			play_animation("attack_up") 
			yield(anim, "animation_finished")
			play_animation("idle_up")
		attack_timer.start()
		cannot_attack = true
		yield(attack_timer, "timeout")
		cannot_attack = false
		is_attacking = false
		

func play_animation(anim_name):
	if anim.animation != anim_name:
		anim.play(anim_name)

func take_damage(damage):
	cur_hp -= damage
	#print("PLayer took damage ", damage)
	if cur_hp <= 0:
		pass
		#print("Player died")

func attack():
	#print("Casting Raycast to" , facing_dir)
	ray_cast.cast_to = facing_dir * interact_dist

	if ray_cast.is_colliding():
		var colliding_node = ray_cast.get_collider()
		if colliding_node is KinematicBody2D:
			colliding_node.take_damage(damage)