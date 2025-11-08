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

func _add_token(token: Token):
	all_tokens.append(token);

func _remove_token(token: Token):
	all_tokens.erase(token);

func _add_factory(factory: Factory):
	all_factories.append(factory);

func _remove_factory(factory: Factory):
	all_factories.erase(factory);

func _move_tokens():
	for i in range(all_tokens.size() - 1, -1, -1):
		var token = all_tokens[i];
		
		if token.target == Vector2i(-1, -1):
			continue;
		
		if _is_tile_empty(token.target):
			token.grid_pos = token.target;
			token.target = token.get_next_target();
		
		elif _is_factory_input(token.target):
			var factory = _get_factory_at_input(token.target)
			var input_id = _get_input_id(token.target, factory)
			if factory and input_id in factory.input_buffer:
				factory.input_buffer[input_id].append(token);
				_remove_token(token);
				token.queue_free();
				token_consumed.emit(token, factory)

func _process_factories():
	for factory in all_factories:
		if factory.progress == 0:
			if can_start_recipe(factory):
				consume_inputs(factory);
				factory.progress = factory.recipe.time;
				factory_started.emit(factory)
		if factory.progress > 0:
			factory.progress -= 1
			
			if factory.progress == 0:
				for item in factory.recipe.outputs:
					for i in range(factory.recipe.outputs[item]):
						factory.output_buffer.append({"item": item})
				
				if "byproduct" in factory.recipe:
					factory.byproducts += 1;
					var freq = factory.recipe.get("byproduct_rate", 1);
					if factory.byproducts >= freq:
						factory.byproducts = 0;
						factory.output_buffer.append({
							"item_type": factory.recipe.byproduct
						})

func _get_outputs():
	pass;


func _is_tile_empty(pos: Vector2i) -> bool:
	for token in all_tokens:
		if token.grid_pos == pos:
			return true;
	return false;

func _is_factory_input(pos: Vector2i) -> bool:
	for factory in all_factories:
		for input_pos in factory.get_inputs():
			if input_pos == pos:
				return true;
	return false;

func _get_factory_at_input(pos: Vector2i) -> Factory:
	for factory in all_factories:
		for input_pos in factory:
			if input_pos == pos:
				return factory;
	return null;

func _get_input_id(pos: Vector2i, factory: Factory) -> String:
	var inputs = factory.get_inputs();
	for i in range(inputs.size()):
		if inputs[i] == pos:
			return factory.recipe.inputs.keys();
	return "";

func _get_next_target(pos: Vector2i) -> Vector2i:
	if not grid:
		return Vector2i(-1, -1);
	var tile_data = grid.get_cell_custom_data();
	
	#match direction
	# I'll add these later, once I know what I'm going to call the direction outputs, also I kinda want a break
	return Vector2i(-1, -1);

func can_start_recipe(factory: Factory) -> bool:
	if factory.recipe.is_empty():
		return false;
	
	for input_id in factory.recipe.inputs:
		var required_inputs = factory.recipe.inputs[input_id];
		var available_inputs = factory.input_buffer.get([input_id], []).size();
		 
		if available_inputs > required_inputs.count:
			return false
		
		if factory.output_buffer.size() >= factory.max_buffer_size:
			return false;
	return true;

func consume_inputs(factory: Factory):
	for input_id in factory.recipe.inputs:
		var required = factory.recipe.inputs[input_id];
		for i in range(required.count):
			factory.input_buffer[input_id].pop_front();
