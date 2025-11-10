extends Node2D

@onready var camera = $"../Camera2D"
@onready var info_label = $"../CanvasLayer/PanelContainer/InfoLabel"
@onready var menu_label = $"../CanvasLayer/PanelContainer/Label"
@onready var recipe_menu = $"../RecipeSelectMenu"
@onready var grid: TileMapLayer = $"../TileMapLayer"
@onready var building_grid = $"../BuildingTileMapLayer"
@onready var ghost_grid = $"../GhostTileMapLayer"

var all_tokens: Array[Token] = [];
var all_factories: Array[Factory] = [];

const ROTATIONS = ["right", "down", "left", "up"]

var paused:bool = false;
var selected_building : String = "";
var is_building_ghost: bool = false;

var building_tiles := {
	"conveyor_belt": [1, Vector2i(0, 0), 0], # 0 == up, 1 == down, 2 == right, 3 == left for the alt_index
	"constructor": [2, Vector2i(0, 0), 0],
	"foundry": [3, Vector2i(0, 0), 0], 
	"manufacturer": [4, Vector2i(0, 0), 0], 
	"miner": [5, Vector2i(0, 0), 0],
	"smelter": [6, Vector2i(0, 0), 0],
};

var mined_count: Dictionary = {}

var ghost_tile_source_id: int = -1
var ghost_tile_coords: Vector2i = Vector2i.ZERO
var ghost_rotation: int = 0
var ghost_cell: Vector2i = Vector2i(-1, -1)

var tickrate: float = 1.0;
var tick_timer = 0.0;

signal factory_started
signal token_consumed
signal factory_output

func _ready():
	_init_building_tile_map()
	menu_label.position = Vector2(3000, 2000)
	info_label.position = Vector2(200, 2000)
	factory_output.connect(_on_factory_output)

func _on_factory_output(item_name: String):
	if not mined_count.has(item_name):
		mined_count[item_name] = 0
	mined_count[item_name] += 1
	_update_label()

func _update_label():
	var text = ""
	for item_name in mined_count.keys():
		text += "%s: %d\n" % [item_name, mined_count[item_name]]
	menu_label.text = text
	if mined_count["gold"] > 1000:
		menu_label.text = "You won, congratulations!"
		camera.zoom = Vector2(2, 2)

#func _init_building_tile_map():
	#var ts: TileSet = building_grid.tile_set
	#if ts == null:
		#push_error("No TileSet assigned to BuildingTileMapLayer")
		#return
	#
	#
	#for source_index in range(ts.get_source_count()):
		#var source = ts.get_source(source_index)
		#if source is TileSetAtlasSource:
			#var tiles_count = source.get_tiles_count()
			#
			#for i in range(tiles_count):
				#var atlas_coords = source.get_tile_id(i)
				#var tile_data = source.get_tile_data(atlas_coords, 0)
				#
				#if tile_data and tile_data.has_custom_data("building_type"):
					#var building_type = tile_data.get_custom_data("building_type")
					#if building_type != null and building_type != "":
						#building_tiles[building_type] = [source_index, atlas_coords, 0]

func _process(delta: float):
	
	if Input.is_action_just_pressed("toggle_pause"):
		if not paused:
			paused = true
		else:
			paused = false;
	if paused:
		return;
	
	tick_timer += delta;
	
	while tick_timer >= tickrate:
		tick_timer -= tickrate;
		_sim_tick();
	
	#if Input.is_action_just_pressed("quit_build_mode"):
		#selected_building = "";
		#if is_building_ghost:
			#is_building_ghost = false;
	
	if not selected_building == "":
		var mouse_pos = get_global_mouse_position()
		var mouse_cell = grid.local_to_map(grid.to_local(mouse_pos))
		if not mouse_cell == ghost_cell:
			ghost_cell = mouse_cell
			_update_ghost_tile()
			
	if Input.is_action_just_pressed("rotate_building"):
		ghost_rotation = (ghost_rotation + 1) % 4
		_update_ghost_tile()
	
	if is_building_ghost == false and selected_building != "":
		var mouse_pos = get_global_mouse_position()
		var mouse_cell = grid.local_to_map(grid.to_local(mouse_pos))
		if mouse_cell != ghost_cell:
			_draw_ghost_tile(mouse_cell)

func _clear_ghost_tile():
	if not ghost_cell == Vector2i(-1, -1):
		ghost_grid.erase_cell(ghost_cell)
		ghost_cell = Vector2i(-1, -1)
#
func _draw_ghost_tile(cell: Vector2i):
	ghost_grid.clear()

	var info = building_tiles.get(selected_building)
	if info == null:
		push_warning("No tile for building: %s" % selected_building)
		return

	var can_place = _can_place_at(cell)
	var color = Color(1, 1, 1, 0.4) if can_place == true else Color(1, 0.2, 0.2, 0.4)

	ghost_grid.set_cell(cell, info["source_id"], info["atlas_coords"])
	ghost_grid.modulate = color


func _init_building_tile_map():
	var ts: TileSet = building_grid.tile_set
	if ts == null:
		push_error("No TileSet assigned to BuildingTileMapLayer")
		return

	building_tiles.clear()

	for source_id in range(ts.get_source_count()):
		var source = ts.get_source(source_id)
		if source is TileSetAtlasSource:

			var atlas_coords = Vector2i(0, 0)
			var tile_data = source.get_tile_data(atlas_coords, 0)
			
			if tile_data and tile_data.has_custom_data("building_type"):
				
				var building_type = tile_data.get_custom_data("building_type")
				
				if building_type != "":
					building_tiles[building_type] = [source_id, atlas_coords, 0]


func _update_ghost_tile():
	is_building_ghost = true
	ghost_grid.clear()
	
	var can_place = _can_place_at(ghost_cell)
	var tile_info = building_tiles.get(selected_building, null)
	if tile_info == null:
		return
	
	var source_id = tile_info[0]
	var atlas_coords = tile_info[1]
	var alt_index = ghost_rotation
	
	ghost_grid.set_cell(ghost_cell, source_id, atlas_coords, alt_index)
	
	ghost_grid.modulate = Color(1, 1, 1, 0.5) if can_place else Color(1, 0.3, 0.3, 0.5)

func _sim_tick():
	_move_tokens();
	_process_factories();
	_do_outputs();

func _register_token(token: Token):
	all_tokens.append(token);

func _remove_token(token: Token):
	all_tokens.erase(token);

func _register_factory(factory: Factory):
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
			token.target = _get_next_target(token.grid_pos);
		
		elif _is_factory_input(token.target):
			var factory = _get_factory_at_input(token.target)
			if factory and factory.accepts_item(token.item) and factory.input_buffer.size() < factory.max_buffer_size:
				factory.input_buffer[token.item].append(token);
				_remove_token(token);
				token.queue_free();
				token_consumed.emit(token, factory)

func _process_factories():
	for factory in all_factories:
		if factory.progress == 0:
			if _can_start_recipe(factory):
				_consume_inputs(factory);
				factory.progress = factory.active_recipe["time"];
				factory_started.emit(factory)
		if factory.progress > 0:
			factory.progress -= 1
			
			if factory.progress == 0:
				for item in factory.active_recipe["outputs"]:
					for i in range(factory.active_recipe["outputs"][item]):
						factory.output_buffer.append({"item": item})
						factory_output.emit(item)

func _do_outputs():
	for factory in all_factories:
		if factory.output_buffer.is_empty():
			continue
		
		if _is_tile_empty(factory.output):
			var token_data = factory.output_buffer.pop_front();
			_spawn_token(token_data.item, factory.output);


func _is_tile_empty(pos: Vector2i) -> bool:
	for token in all_tokens:
		if token.grid_pos == pos:
			return false;
	return true;

func _is_factory_input(pos: Vector2i) -> bool:
	for factory in all_factories:
		for input_pos in factory.get_inputs():
			if input_pos == pos and not factory.input_buffer.size() > factory.max_buffer_size:
				return true;
	return false;

func _get_factory_at_input(pos: Vector2i) -> Factory:
	for factory in all_factories:
		for input_pos in factory.get_inputs():
			if input_pos == pos:
				return factory;
	return null;

func _get_next_target(pos: Vector2i) -> Vector2i:
	if not grid:
		return Vector2i(-1, -1);
	var tile_data = grid.get_cell_tile_data(pos);
	if not tile_data:
		return Vector2i(-1, -1);
	
	var direction = tile_data.get_custom_data("direction");
	
	match direction:
		"right":
			return pos + Vector2i(1, 0);
		"left":
			return pos + Vector2i(-1, 0);
		"up":
			return pos + Vector2i(0, -1)
		"down":
			return pos + Vector2i(0, 1);
		_:
			return Vector2i(-1, -1);

func _can_start_recipe(factory: Factory) -> bool:
	if not factory.active_recipe or factory.active_recipe.is_empty():
		return false;
	
	for item_type in factory.active_recipe["inputs"].keys():
		var required_inputs = factory.active_recipe["inputs"]["item_type"];
		var available_inputs = factory.input_buffer.get(item_type, []).size();
		 
		if available_inputs < required_inputs:
			return false
		
		if factory.output_buffer.size() >= factory.max_buffer_size:
			return false;
	return true;

func _consume_inputs(factory: Factory):
	for item in factory.active_recipe["inputs"].keys():
		var required_count = factory.active_recipe["inputs"][item]
		for i in range(required_count):
			if factory.input_buffer.get(item, []).size() > 0:
				factory.input_buffer[item].pop_front()

func _spawn_token(item: String, pos: Vector2i) -> Token:
	var token = Token.new(item, pos)
	token.target = _get_next_target(pos)
	
	if grid:
		token.global_position = grid.map_to_local(pos)
	
	else:
		push_warning("ERROR TileMapLayer not found, token may be in the wrong position")
	
	_register_token(token)
	add_child(token)
	
	return token

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not selected_building == "" and is_building_ghost:
			var mouse_pos = get_global_mouse_position()
			var cell = grid.local_to_map(grid.to_local(mouse_pos))
			_place_building(cell, selected_building, ghost_rotation)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var mouse_pos = get_global_mouse_position()
		var cell = grid.local_to_map(grid.to_local(mouse_pos))
		var factory = _get_factory_at_cell(cell)
		if factory and factory.recipe_cont.size() > 1:
			recipe_menu.open_for_building(factory)


func _place_building(cell: Vector2i, building_type: String, rotation_index: int = 0):
	var info = building_tiles.get(building_type)
	if info == null:
		push_error("Unknown building: %s" % building_type)
		return
	
	building_grid.set_cell(cell, info[0], info[1], rotation_index)
	_register_building_at(cell, building_type, rotation_index)
	_clear_ghost_tile()


func _can_place_at(cell: Vector2i) -> bool:
	if not grid.get_cell_tile_data(cell):
		return false;
	
	for factory in all_factories:
		if factory.pos == cell:
			return false
	
	return true;

func create_building_preview():
	if selected_building == "":
		return
	
	if not building_tiles.has(selected_building):
		push_error("Unknown building: %s" % selected_building)
		return
	
	var tile_info = building_tiles[selected_building]
	ghost_tile_source_id = tile_info[0]
	ghost_tile_coords = tile_info[1]
	
	_update_ghost_tile()

func _get_factory_at_cell(cell: Vector2i) -> Factory:
	for factory in all_factories:
		if factory.pos == cell:
			return factory
	return null

func _register_building_at(cell: Vector2i, building_name: String, angle: int):
	var building: Factory = null
	
	match building_name:
		"miner":
			building = Miner.new()
		"smelter":
			building = Smelter.new()
		"foundry":
			building = Foundry.new()
		_:
			push_error("Unknown building: %s" % building_name)
			return
	
	building.pos = cell
	building.rotation_index = angle
	building.global_position = grid.map_to_local(cell)
	
	add_child(building)
	
	_register_factory(building)


#func _get_tile_building_type(building_name: String) -> int:
	#var ts: TileSet = building_grid.tile_set
	#if not ts:
		#push_error("No TileSet found")
		#return -1
#
	#for source_index in range(ts.get_source_count()):
		#var source = ts.get_source(source_index)
		#if source is TileSetAtlasSource:
			#var tile_count = source.get_tiles_count()
			#for tile_index in range(tile_count):
				#var atlas_coords = source.get_tile_id(tile_index)
				#var tile_data = source.get_tile_data(atlas_coords, 0)
				#
				#if tile_data and tile_data.has_custom_data("building_type"):
					#var found_name = tile_data.get_custom_data("building_type")
					#if found_name == building_name:
						#return ts.get_tile_id(source_index, atlas_coords)
#
	#return -1
