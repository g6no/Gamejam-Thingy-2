extends RigidBody2D


var direction : Vector2 = Vector2.LEFT # default direction
export var speed : float = 1000 #put your rocket speed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	translate(direction*speed*delta)


func _on_DestroyTimer_timeout():
	queue_free()
