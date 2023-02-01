extends KinematicBody2D


var projectile = preload("res://projectile.tscn")
onready var player = get_parent().get_node("Player")

func _ready():
	pass # Replace with function body.


func _on_FireRate_timeout():
	var projectile_inst = projectile.instance()
	get_tree().get_root().add_child(projectile_inst)
	projectile_inst.global_position = global_position
	var dir = (player.global_position - global_position).normalized()
	#projectile_inst.global_rotation = dir.angle() + PI / 2.0
	projectile_inst.direction = dir

