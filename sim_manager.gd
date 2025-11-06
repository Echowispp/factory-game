extends Node2D

var all_tokens: Array[Token] = [];
var all_factories: Array[Factory] = [];

var grid: TileMapLayer = null

var paused:bool = false;
var tickrate: float = 1.0; #basically how fast the sim runs

var tick_timer = 0.0; #Used so tickrate can be controlled

signal tick_completed(tick: int);
signal factory_started

#func _ready() -> void:
	#pass
func _process(delta: float) -> void:
	
	if paused:
		return;
	
	tick_timer += delta;
	
	while tick_timer >= tickrate:
		tick_timer -= tickrate;
		_sim_tick();

func _sim_tick():
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
