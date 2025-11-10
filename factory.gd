class_name Factory
extends Node2D

const Z_INDEX: int = 5

var type: String = ""
var pos: Vector2i = Vector2i(0, 0)
var rotation_index: int = 0
const ROTATIONS = ["right", "down", "left", "up"]

var max_buffer_size: int = 3
var input_buffer: Dictionary = {}
var output_buffer: Array = []
var output: Vector2i = Vector2i(0, 0)

var active_recipe: Dictionary = {}
var active_recipe_name: String = ""
var recipe_cont: Dictionary = {}

var input_count: int = 1
var progress: int = 0

var sprite: Sprite2D
var progress_bar: ProgressBar

func _ready():
	z_index = Z_INDEX
	sprite = Sprite2D.new()
	sprite.centered = true
	add_child(sprite)
	
	_load_sprite()
	_setup_progress_bar()
	_initialize_buffers()

func _load_sprite():
	if type == "":
		push_warning("Factory type not set, ERROR loading texture!")
		sprite.texture = PlaceholderTexture2D.new()
		return
	
	var sprite_path = "res://sprites/factories/%s.png" % type
	
	if ResourceLoader.exists(sprite_path):
		sprite.texture = load(sprite_path)
	else:
		push_warning("Sprite not found: %s" % sprite_path)
		sprite.texture = PlaceholderTexture2D.new()

func _setup_progress_bar():
	progress_bar = ProgressBar.new()
	progress_bar.position = Vector2(-16, -24)
	progress_bar.size = Vector2(32, 4)
	progress_bar.show_percentage = false
	progress_bar.visible = false
	add_child(progress_bar)

func _process(_delta):
	if progress_bar:
		if is_working():
			progress_bar.visible = true
			progress_bar.max_value = active_recipe["time"]  
			progress_bar.value = active_recipe["time"] - progress  
		else:
			progress_bar.visible = false

func _initialize_buffers():
	if active_recipe.has("inputs"):
		for item_type in active_recipe["inputs"]: 
			input_buffer[item_type] = []



func _update_visual_rotation():
	sprite.rotation_degrees = rotation_index * 90

func _update_io_positions():
	match ROTATIONS[rotation_index]:
		"right":
			output = pos + Vector2i(1, 0)
		"down":
			output = pos + Vector2i(0, 1)
		"left":
			output = pos + Vector2i(-1, 0)
		"up":
			output = pos + Vector2i(0, -1)

func get_current_direction() -> String:
	return ROTATIONS[rotation_index]



func get_inputs() -> Array:
	var inputs = []
	var direction = ROTATIONS[rotation_index]
	
	match input_count:
		0:
			return []
		1:
			match direction:
				"right":
					inputs.append(pos + Vector2i(-1, 0))
				"down":
					inputs.append(pos + Vector2i(0, -1))
				"left":
					inputs.append(pos + Vector2i(1, 0))
				"up":
					inputs.append(pos + Vector2i(0, 1))
		2:
			match direction:
				"right":
					inputs.append(pos + Vector2i(0, -1))
					inputs.append(pos + Vector2i(0, 1))
				"down":
					inputs.append(pos + Vector2i(-1, 0))
					inputs.append(pos + Vector2i(1, 0))
				"left":
					inputs.append(pos + Vector2i(0, -1))
					inputs.append(pos + Vector2i(0, 1))
				"up":
					inputs.append(pos + Vector2i(-1, 0))
					inputs.append(pos + Vector2i(1, 0))
		3:
			match direction:
				"right":
					inputs.append(pos + Vector2i(-1, 0))
					inputs.append(pos + Vector2i(0, -1))
					inputs.append(pos + Vector2i(0, 1))
				"down":
					inputs.append(pos + Vector2i(-1, 0))
					inputs.append(pos + Vector2i(0, -1))
					inputs.append(pos + Vector2i(1, 0))
				"left":
					inputs.append(pos + Vector2i(1, 0))
					inputs.append(pos + Vector2i(0, -1))
					inputs.append(pos + Vector2i(0, 1))
				"up":
					inputs.append(pos + Vector2i(-1, 0))
					inputs.append(pos + Vector2i(0, 1))
					inputs.append(pos + Vector2i(1, 0))
	
	return inputs



func set_active_recipe(recipe_name: String):
	if not recipe_cont.has(recipe_name):
		push_error("Recipe not found: %s" % recipe_name)
		return
	
	active_recipe_name = recipe_name
	active_recipe = recipe_cont[recipe_name]
	_initialize_buffers()



func accepts_item(item_type: String) -> bool:
	if not active_recipe.has("inputs"):
		return false
	return item_type in active_recipe["inputs"] 

func has_space_for_item(item_type: String) -> bool:
	var current_count = input_buffer.get(item_type, []).size()
	var max_per_item = 10
	return current_count < max_per_item

func is_idle() -> bool:
	return progress == 0

func is_working() -> bool: 
	return progress > 0

func get_progress_percent() -> float:
	if not active_recipe.has("time") or active_recipe["time"] == 0:
		return 0.0
	return 1.0 - (float(progress) / float(active_recipe["time"]))  

func has_required_inputs() -> bool:  
	if not active_recipe.has("inputs"):
		return false
	
	for item_type in active_recipe["inputs"]:  
		var required_count = active_recipe["inputs"][item_type] 
		var available_count = input_buffer.get(item_type, []).size()
		
		if available_count < required_count:
			return false
	
	return true
