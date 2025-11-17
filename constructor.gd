class_name Constructor
extends Factory

func _init():
	type = "constructor"
	input_count = 1
	rotation_index = 0

func _ready() -> void:
	super._ready()
	
	input_count = 1
	
	recipe_cont = {
		"wire": {
			"inputs": {
				"copper_ingot": 1,
			},
			"outputs": {
				"wire": 1,
			},
			"time": 2,
		},
	}
	
	set_active_recipe("wire")
	_update_io_positions()
