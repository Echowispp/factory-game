extends Node2D

@onready var tile_map = $/TileMapLayer

var all_tokens: Array[Token] = [];
var all_factories: Array[Factory] = [];

var grid: TileMapLayer = null

var paused:bool = false;
var tickrate: float = 1.0; #basically how fast the sim runs

var tick_timer = 0.0; #Used so tickrate can be controlled

signal tick_completed(tick: int);
signal factory_started
signal token_consumed
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
	all_tokens.append(token);

func remove_token(token: Token):
	all_tokens.erase(token);

func add_factory(factory: Factory):
	all_factories.append(factory);

func remove_factory(factory: Factory):
	all_factories.erase(factory);

func _move_tokens():
	for i in range(all_tokens.size() - 1, -1, -1):
		var token = all_tokens[i];
		
		if token.target == Vector2i(-1, -1):
			continue;
		
		if is_tile_empty(token.target):
			token.grid_pos = token.target;
			token.target = token.get_next_target();
		
		elif is_factory_input(token.target):
			var factory = get_factory_at_input(token.target)
			var input_id = get_input_id(token.target, factory)
			if factory and input_id in factory.input_buffers:
				factory.input_buffers[input_id].append(token);
				remove_token(token);
				token.queue_free();
				token_consumed.emit(token, factory)

func _process_factories():
	pass;

func _get_outputs():
	pass;


func is_tile_empty(pos: Vector2i) -> bool:
	for token in all_tokens:
		if token.grid_pos == pos:
			return true;
	return false;

func is_factory_input(pos: Vector2i) -> bool:
	for factory in all_factories:
		for input_pos in factory.get_inputs():
			if input_pos == pos:
				return true;
	return false;

func get_factory_at_input(pos: Vector2i) -> Factory:
	for factory in all_factories:
		for input_pos in factory:
			if input_pos == pos:
				return factory;
	return null;

func get_input_id(pos: Vector2i, factory: Factory) -> String:
	var inputs = factory.get_inputs();
	for i in range(inputs.size()):
		if inputs[i] == pos:
			return factory.recipe.inputs.keys();
	return "";

func get_next_tile(pos: Vector2i) -> Vector2i:
	if not grid:
		return Vector2i(-1, -1);
	var tile_data = grid.get_cell_custom_data();
	
	#match direction
	# I'll add these later, once I know what I'm going to call the direction outputs, also I kinda want a break
	return Vector2i(-1, -1)
