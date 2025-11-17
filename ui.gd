extends Control

@onready var info_label = $InfoLabel

@onready var sim_manager = $"../../SimManager";

@onready var conveyor_button = $HBoxContainer/ConveyorButton;
@onready var miner_button = $HBoxContainer/MinerButton;
@onready var smelter_button = $HBoxContainer/SmelterButton;
@onready var foundry_button = $HBoxContainer/FoundryButton;
@onready var constructor_button = $HBoxContainer/ConstructorButton;
@onready var manufacturer_button = $HBoxContainer/ManufacturerButton;
@onready var trash_button = $"HBoxContainer/TrashButton"

@onready var recipe_button = $"HBoxContainer/RecipeButton"

var recipe_text = "
=== MINERS ===
Miner on top of iron (the white stuff):    -> iron_ore
Miner on top of coal (the black stuff):    -> coal_ore
Miner on top of copper (the orange stuff): -> copper_ore

=== SMELTER ===
Iron Ingot: iron_ore + coal_ore -> iron_ingot
Copper Ingot: copper_ore + coal_ore -> copper_ingot

=== FOUNDRY ===
Steel Ingot: iron_ingot + coal_ore -> steel_ingot

=== CONSTRUCTOR ===
Wire: copper_ingot -> wire

=== MANUFACTURER ===
Circuit Board: copper_ingot + iron_ingot -> circuit_board
Computer: circuit_board + steel_ingot -> computer
"

func _ready():
	conveyor_button.pressed.connect(_conveyor);
	miner_button.pressed.connect(_miner)
	smelter_button.pressed.connect(_smelter)
	foundry_button.pressed.connect(_foundry)
	constructor_button.pressed.connect(_constructor)
	manufacturer_button.pressed.connect(_manufacturer)
	trash_button.pressed.connect(_trash)
	recipe_button.pressed.connect(_show_recipe_book)


func _conveyor():
	sim_manager.selected_building = "conveyor_belt";
	sim_manager.create_building_preview()
func _miner():
	sim_manager.selected_building = "miner";
	sim_manager.create_building_preview()
func _smelter():
	sim_manager.selected_building = "smelter";
	sim_manager.create_building_preview()
func _foundry():
	sim_manager.selected_building = "foundry";
	sim_manager.create_building_preview()
func _constructor():
	sim_manager.selected_building = "constructor";
	sim_manager.create_building_preview()
func _manufacturer():
	sim_manager.selected_building = "manufacturer";
	sim_manager.create_building_preview()
func _trash():
	sim_manager.selected_building = "trash"
	sim_manager.create_building_preview()

func _show_recipe_book():
	if not info_label.visible == true:
		info_label.text = recipe_text
		info_label.visible = true
	else:
		info_label.visible = false
