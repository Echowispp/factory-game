extends Node2D



var all_tokens: Array[Token] = [];
var all_factories: Array[Factory] = [];


#func _ready() -> void:
	#pass


#func _process(delta: float) -> void:
	#pass

func sim_tick():
	_move_tokens();
	_process_factories();
	_get_outputs();

func add_token(token: Token):
	all_tokens.append(token)

func remove_token(token: Token):
	all_tokens.erase(token)

func _move_tokens():
	pass;

func _process_factories():
	pass;

func _get_outputs():
	pass;
