class_name Smelter;

extends Factory;


func _init():
	type = "smelter";
	input_count = 2;

	rotation_index = 0;
	recipe_cont = {"iron_ingot":{
		"inputs":{
			"iron_ore": 2, 
			"coal_ore": 1, 
		}, 
		"outputs": {
			"iron_ingot": 2, 
			#"slag": 1, 
		},
		"time": 4,
	}, 
	"copper_ingot":{
		"inputs":{
			"copper_ore": 2, 
			"coal": 1, 
		}, 
		"outputs": {
			"copper_ingot": 2,
			#"slag": 1,  
		}, 
		"time": 4, 
	}, 
	};
	
	set_active_recipe("iron_ingot");
	_update_io_positions();

func _ready() -> void:
	super._ready();
	input_count = 2;

func set_active_recipe(recipe: String):
	if not recipe_cont.has(recipe):
		return;
	active_recipe_name = recipe;
	active_recipe = recipe_cont[recipe];
