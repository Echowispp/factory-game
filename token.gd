extends Node2D;

class_name Token;

const NO_TARGET = Vector2i(-1, -1)
const SPRITE_SIZE: int = 16
const Z_INDEX: int = 10;

var needs_conveyor_check: bool = false

var item: String = "";
var grid_pos: Vector2i = Vector2i(0, 0);
var target: Vector2i = Vector2i(-1, -1);

var sprite;

func _ready() -> void:
	z_index = Z_INDEX;
	_setup_visual();

func _init(type: String = "", pos: Vector2i = Vector2i(0, 0)):
	item = type;
	grid_pos = pos;
	target = Vector2i(-1, -1);

func _setup_visual():
	sprite = Sprite2D.new()
	sprite.centered = true
	add_child(sprite)
	
	_update_sprite()

func _update_sprite():
	var sprite_path = "res://images/%s.png" % item  
	
	if ResourceLoader.exists(sprite_path):
		sprite.texture = load(sprite_path)
	else:
		# Fallback to colored square if sprite not found
		push_warning("Sprite not found for item: %s" % item)
		var image = Image.create(16, 16, false, Image.FORMAT_RGBA8)
		image.fill(_get_item_color())
		sprite.texture = ImageTexture.create_from_image(image)

func _get_item_color() -> Color: # fallback in case of issues
	match item:
		"iron_ore":
			return Color("#964");
		"coal_ore":
			return Color("#222");
		"copper_ore":
			return Color("#c83");
		"iron_ingot":
			return Color("#bbb");
		"copper_ingot":
				return Color("#d4773d")
		"steel_ingot":
			return Color("#89a");
		"wire":
			return Color("#e69a19");
		"screw":
			return Color("#cde");
		"slag":
			return Color("#753");
		"circuit_board":
			return Color("#171");
		"concrete":
			return Color("#888");
		"stone":
			return Color("#555");
		_:
			return Color("#f0f"); # "error color"
