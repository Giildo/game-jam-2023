class_name Bloc
extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var multi_velocity = Vector2(200, 100)
export var multi_rotate = 200000
export var basic_fall_speed = 0.2 #Modificateur de vitesse de chute appliquee a l'objet lorsque le stick n'est pas vers le bas
export var floor_lin_damp = 0.0 #Deceleration lineaire au sol
export var floor_ang_damp = 0.0 #Deceleration de rotation au sol

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
		if velocity_t <= 0:
			velocity_t = velocity_t / 3 + basic_fall_speed
		else:
			velocity_t = velocity_t + basic_fall_speed
		var target_rotation = Input.get_axis(
			"p%d_rotate_left" % player_index, 
			"p%d_rotate_right" % player_index
		)
		
		applied_force = Vector2(velocity_h, velocity_t) * multi_velocity * mass
		applied_torque = target_rotation * multi_rotate * mass

func stop_item():
	collision_layer = 0b11
	collision_mask = 0b1
	controlled = false
	contact_monitor = false
	contacts_reported = 0
	linear_damp = floor_lin_damp
	angular_damp = floor_ang_damp
	emit_signal("on_floor")
	Input.start_joy_vibration(player_index - 1, 0, 0.75, 0.4)

func has_collision (item: PhysicsBody2D) -> void:
	if item is StaticBody2D and not item.is_in_group("walls"):
		stop_item()
	elif item.is_in_group("blocs"):
		if not item.controlled:
			stop_item()
		else :
			Input.start_joy_vibration(player_index - 1, 0.5, 0.25, 0.2)
