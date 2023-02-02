extends KinematicBody2D

export var move_speed = 100
export var wait_between_points = 1
export var waiting = false
#export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0
var velocity = Vector2.ZERO

onready var patrol_path = get_node("/root/Huh?/Path2D")

func _ready():
	if patrol_path:
		patrol_points = patrol_path.curve.get_baked_points()

func _physics_process(delta):

	if !patrol_path:
		return
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		var timer = get_tree().create_timer(1)
		waiting = true
		$AnimatedSprite2.stop()
		yield(timer, "timeout")
		waiting = false
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	
	if not waiting:
		var distance = (target- position).normalized()
		print(distance)
		play_enemy_animation(distance)
		velocity = distance * move_speed
		velocity = move_and_slide(velocity)

func play_enemy_animation(enemy_to_player):
	if enemy_to_player.x >= 0.5:
		$AnimatedSprite2.play("right")
	elif enemy_to_player.x < -0.5:
		$AnimatedSprite2.play("left")
	elif enemy_to_player.y > 0.5:
		$AnimatedSprite2.play("down")
	elif enemy_to_player.y < -0.5:
		$AnimatedSprite2.play("up") 
