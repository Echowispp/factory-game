extends Node2D;

class_name Factory;

var max_buffer_size: int = 3;
var item: String;
var pos: Vector2i;
var input_buffer: Dictionary = {};
var output_buffer: Array = [];
var recipe: Dictionary = {};
var progress: int = 0;
var byproducts: int = 0
var output: Vector2i;

func _ready():
	var sprite = Sprite2D.new();
	add_child(sprite);
	sprite.texture = PlaceholderTexture2D
	#actual sprite to be added
