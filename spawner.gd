class_name Spawner
extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bloc
var type
var nb: int
var player_index: int
var current_block: Bloc

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
			"proba": 1.5,
		},
		{
			"bloc": preload("res://blocs/student/ruler.tscn"),
			"proba": 4.0,
		},
		{
			"bloc": preload("res://blocs/student/slate.tscn"),
			"proba": 4.5,
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
	print(characterType, nb, player_index)
	type = characterType
	self.nb = nb
	self.player_index = player_index

#func _input(event):

func get_block(range_nb: float) -> Bloc:
	var proba: float = 0
	for bloc_settings in blocs_scenes[type]:
		proba = bloc_settings.proba
		print(range_nb, proba)
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
	var spawn_position = Vector2(
		(get_viewport().size.x * (player_index + 1)) / (nb + 1),
		 50
	)
	randomize()
	current_block = get_block(rand_range(0, 10))
	current_block.position = spawn_position
	current_block.connect("on_floor", self, "new_spawn")
	add_child(current_block)

func new_spawn() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	spawn()

func _physics_process(delta):
	pass
