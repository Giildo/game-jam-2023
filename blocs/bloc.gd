extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var multi_velocity = Vector2(200, 100)
var multi_rotate = 200000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _integrate_forces(state):
	var velocity_h = Input.get_axis("p1_left", "p1_right")
	var velocity_t = Input.get_axis("p1_top", "p1_bottom")
	var target_rotation = Input.get_axis("p1_rotate_left", "p1_rotate_right")
	
	applied_force = Vector2(velocity_h, velocity_t) * multi_velocity
	applied_torque = target_rotation * multi_rotate


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
