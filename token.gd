extends Node2D;

class_name Token;

var item: String;
var pos: Vector2i;
var target: Vector2i;

func _ready() -> void:
	var sprite = Sprite2D.new();
	add_child(sprite);
	sprite.texture = PlaceholderTexture2D
	#actual sprite to be added
