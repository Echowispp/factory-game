extends Control

signal recipe_selected(recipe_name: String);

@onready var option_button: OptionButton = $Panel/OptionButton
var building_ref: Factory = null

func _ready():
	hide()
	option_button.item_selected.connect(_on_item_selected)

func open_for_building(factory: Factory):
	building_ref = factory
	option_button.clear()
	
	for recipe_name in factory.recipe_cont.keys():
		option_button.add_item(recipe_name)
	
	if not factory.active_recipe_name == "":
		var idx = -1
		for i in range(option_button.item_count):
			if option_button.get_item_text(i) == factory.active_recipe_name:
				idx = i
				break
		if not idx == -1:
			option_button.select(idx)
	
	show()
	position = get_viewport().get_mouse_position()

func _on_item_selected(index: int):
	if not building_ref:
		return
	
	var recipe_name = option_button.get_item_text(index)
	building_ref.set_active_recipe(recipe_name)
	emit_signal("recipe_selected", recipe_name)
	hide()
