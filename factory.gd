extends Node2D;

class_name Factory;

var item: String;
var pos: Vector2i;
var input_buffers: Dictionary = {};
var output_buffers: Array = [];
var recipe: Dictionary = {};
var output: Vector2i;

func _ready() -> void:
	var sprite = Sprite2D.new();
	add_child(sprite);
	sprite.texture = PlaceholderTexture2D
	#actual sprite to be added
