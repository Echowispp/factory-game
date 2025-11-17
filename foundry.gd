class_name Foundry
extends Factory

func _init():
	type = "foundry"
	input_count = 2
	rotation_index = 0

func _ready() -> void:
	super._ready()
	
	input_count = 2
	
	recipe_cont = {
		"steel_ingot": {
			"inputs": {
				"iron_ingot": 2,
				"coal_ore": 1,
			},
			"outputs": {
				"steel_ingot": 1,
			},
			"time": 5,
		},
	}
	
	set_active_recipe("steel_ingot")
	_update_io_positions()
