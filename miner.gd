class_name Miner;

extends Factory;

@onready var grid = $"../../TileMapLayer"

func _init():
	type = "miner";
	input_count = 0;


func _ready() -> void:
	super._ready();
	
	var mined_resource_type = _check_mined_tile();
	
	active_recipe = {
		"inputs": {}, 
		"outputs": {
			mined_resource_type: 1, 
		},
		"time": 1, 
	};
	
	_update_io_positions();

func _check_mined_tile() -> String:
	
	var sim_manager = get_parent()
	if not sim_manager or not sim_manager.grid:
		push_error("ERROR Miner: Cannot find grid!")
		return "iron_ore"
		
	var cell: Vector2i = grid.local_to_map(grid.to_local(global_position))
	var tile_data: TileData = grid.get_cell_tile_data(cell);
	
	if tile_data == null:
		return "";
		
	var resource_type = tile_data.get_custom_data("ore_type");
	
	if tile_data == null:
		return ""
	
	
	if resource_type != null:
		return str(resource_type)
	
	return ""
	
func _update_io_positions():
	
	output.clear();
	
	match ROTATIONS[rotation_index]:
		"right":
			output.append(pos + Vector2i(1, 0))
		"down":
			output.append(pos + Vector2i(0, 1))
		"left":
			output.append(pos + Vector2i(-1, 0))
		"up":
			output.append(pos + Vector2i(0, -1))
