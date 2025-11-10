extends Node2D;

class_name Token;

const Z_INDEX: int = 10;

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
	sprite = Sprite2D.new();
	sprite.centered = true;
	add_child(sprite);
	
	_update_sprite();

func _update_sprite():
	var color = _get_item_color();
	var image = Image.create(16, 16, false, Image.FORMAT_RGBA8);
	image.fill(color);
	var texture = ImageTexture.create_from_image(image);
	sprite.texture = texture;

func _get_item_color() -> Color:
	match item:
		"iron":
			return Color("#964");
		"coal":
			return Color("#222");
		"copper":
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
		_:
			return Color("#f0f"); # "error color"
		# I'll replace these with sprites later
