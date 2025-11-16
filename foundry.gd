class_name Foundry;

extends Factory;


func _init():
	type = "foundry";
	input_count = 0;
	rotation_index = 0;
	recipe_cont = {
		"steel_ingot":{
			"inputs":{
				"iron_ingot": 2, 
				"coal": 1, 
			}, 
			"outputs":{
				"steel_ingot": 2, 
			}, 
			"time": 4, 
		}
	};
	
	set_active_recipe("steel_ingot");

func _ready() -> void:
	super._ready();
	_update_io_positions();

func set_active_recipe(recipe: String):
	if not recipe_cont.has(recipe):
		return;
	active_recipe_name = recipe;
	active_recipe = recipe_cont[recipe];


func _update_io_positions():
	match ROTATIONS[rotation_index]:
		"right":
			output.append(pos + Vector2i(1, 0))
		"down":
			output.append(pos + Vector2i(0, 1))
		"left":
			output.append(pos + Vector2i(-1, 0))
		"up":
			output.append(pos + Vector2i(0, -1))
