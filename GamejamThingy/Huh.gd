extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var increase = 3

onready var pathfollow = $Path2D.get_node("PathFollow2D")
onready var path = $Path2D
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	print(path.get_curve().tessellate())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pathfollow.offset += increase
