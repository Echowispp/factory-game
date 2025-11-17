class_name Manufacturer
extends Factory

func _init():
	type = "manufacturer"
	input_count = 3
	rotation_index = 0

func _ready() -> void:
	super._ready()
	
	input_count = 3
	
	recipe_cont = {
		"circuit_board": {
			"inputs": {
				"copper_ingot": 1,
				"iron_ingot": 1,
			},
			"outputs": {
				"circuit_board": 1,
			},
			"time": 4,
		},
		"computer": {
			"inputs": {
				"circuit_board": 1,
				"steel_ingot": 1,
			},
			"outputs": {
				"computer": 1,
			},
			"time": 6,
		},
	}
	
	set_active_recipe("circuit_board")
	_update_io_positions()
