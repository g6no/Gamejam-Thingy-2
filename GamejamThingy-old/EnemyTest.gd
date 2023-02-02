extends KinematicBody2D

var cur_hp = 5
var max_hp = 5

var damaged = false

# Exported Variables
export var move_speed = 150
export var xp_to_give = 30
export var damage = 1
export var attack_rate : float = 0.5
export var attack_distance = 80
export var chase_distance = 400

# Onready Variables
onready var timer = $Timer
onready var damage_timer = $DamageTimer
onready var player = get_node("/root/MainRoom/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = attack_rate
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var distance = position.distance_to(player.position)

	if distance > attack_distance and distance < chase_distance:
		var vel = (player.position - position).normalized()
		move_and_slide(vel * move_speed)

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

func die():
	#player.give_xp(xp_to_give)
	print("Enemy died!")
	queue_free()
