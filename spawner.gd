class_name Spawner
extends Node


var bloc
var type
var nb: int
var player_index: int
var current_block: Bloc
var can_spawn = true

signal has_spawned

enum CharactersType {
	STUDENT,
	BUILDER,
	DOCTOR,
	GAMER,
	TRANSLATOR,
}

var blocs_scenes = {
	CharactersType.STUDENT: [
		{
			"bloc": preload("res://blocs/student/ball.tscn"),
			"proba": 1.6,
		},
		{
			"bloc": preload("res://blocs/student/ruler.tscn"),
			"proba": 4.3,
		},
		{
			"bloc": preload("res://blocs/student/slate.tscn"),
			"proba": 4.1,
		},
	],
	CharactersType.GAMER: [
#		{
#			"bloc": preload("res://blocs/gamer/controller.tscn"),
#			"proba": 4.1,
#		},
		{
			"bloc": preload("res://blocs/gamer/game.tscn"),
			"proba": 2.5,
		},
		{
			"bloc": preload("res://blocs/gamer/vita.tscn"),
			"proba": 3.0,
		},
	],
	CharactersType.BUILDER: [
		{
			"bloc": preload("res://blocs/btp/cone.tscn"),
			"proba": 2.9,
		},
		{
			"bloc": preload("res://blocs/btp/sign.tscn"),
			"proba": 2.2,
		},
		{
			"bloc": preload("res://blocs/btp/trestle.tscn"),
			"proba": 4.9,
		},
	],
	CharactersType.DOCTOR: [
		{
			"bloc": preload("res://blocs/doctor/bone.tscn"),
			"proba": 3.5,
		},
		{
			"bloc": preload("res://blocs/doctor/lung.tscn"),
			"proba": 2.5,
		},
		{
			"bloc": preload("res://blocs/doctor/muscle.tscn"),
			"proba": 4.0,
		},
	],
	CharactersType.TRANSLATOR: [
		{
			"bloc": preload("res://blocs/translator/4.tscn"),
			"proba": 2.0,
		},
		{
			"bloc": preload("res://blocs/translator/d.tscn"),
			"proba": 2.0,
		},
		{
			"bloc": preload("res://blocs/translator/m.tscn"),
			"proba": 2.0,
		},
		{
			"bloc": preload("res://blocs/translator/ma.tscn"),
			"proba": 2.0,
		},
		{
			"bloc": preload("res://blocs/translator/omega.tscn"),
			"proba": 2.0,
		},
	]
}

func _init(characterType, nb: int, player_index):
	type = characterType
	self.nb = nb
	self.player_index = player_index

#func _input(event):

func get_block(range_nb: float) -> Bloc:
	var proba: float = 0
	for bloc_settings in blocs_scenes[type]:
		proba += bloc_settings.proba
		if range_nb <= proba:
			return  bloc_settings.bloc.instance()
			
	return blocs_scenes[type][blocs_scenes[type].size() - 1].bloc.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn() -> void:
	if not can_spawn:
		return
	
	var spawn_position = Vector2(
		(get_viewport().size.x * (player_index + 1)) / (nb + 1),
		 -get_viewport().canvas_transform.origin.y
	)
	randomize()
	current_block = get_block(rand_range(0, 10))
	current_block.position = spawn_position
	current_block.rotation = rand_range(0, 1) * TAU
	current_block.player_index = player_index + 1
	emit_signal("has_spawned")
	current_block.connect("on_floor", self, "new_spawn")
	add_child(current_block)

func new_spawn() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	spawn()

func _physics_process(delta):
	pass
