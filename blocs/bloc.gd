class_name Bloc
extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var multi_velocity = Vector2(200, 100)
var multi_rotate = 200000

var player_index = 0

var controlled = false

signal on_floor

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	contacts_reported = 1
	controlled = true
	
	connect("body_entered", self, "has_collision")

func _integrate_forces(state):
	print(player_index)
	applied_force = Vector2.ZERO
	applied_torque = 0.0
	if (controlled):
		var velocity_h = Input.get_axis(
			"p%d_left" % player_index,
			"p%d_right" % player_index
		)
		var velocity_t = Input.get_axis(
			"p%d_top" % player_index, 
			"p%d_bottom" % player_index
		)
		var target_rotation = Input.get_axis(
			"p%d_rotate_left" % player_index, 
			"p%d_rotate_right" % player_index
		)
		
		applied_force = Vector2(velocity_h, velocity_t) * multi_velocity
		applied_torque = target_rotation * multi_rotate

func stop_item():
	collision_layer = 0b11
	controlled = false
	contact_monitor = false
	contacts_reported = 0
	emit_signal("on_floor")

func has_collision (item: PhysicsBody2D) -> void:
	if item is StaticBody2D:
		stop_item()
	elif item.is_in_group("blocs") and not item.controlled:
		stop_item()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
