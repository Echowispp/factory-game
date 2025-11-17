class_name Trash
extends Factory

func _init():
	type = "trash"
	input_count = 1
	rotation_index = 0

func _ready() -> void:
	super._ready()
	
	active_recipe = {
		"inputs": {},  
		"outputs": {},
		"time": 0,  
	}
	
	_update_io_positions()

func accepts_item(item_type: String) -> bool:
	return true  
