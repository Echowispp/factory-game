extends Control



@onready var sim_manager = $"../../SimManager";

@onready var conveyor_button = $HBoxContainer/ConveyorButton;
@onready var miner_button = $HBoxContainer/MinerButton;
@onready var smelter_button = $HBoxContainer/SmelterButton;
@onready var foundry_button = $HBoxContainer/FoundryButton;
@onready var constructor_button = $HBoxContainer/ConstructorButton;
@onready var manufacturer_button = $HBoxContainer/ManufacturerButton;


func _ready():
	conveyor_button.pressed.connect(_conveyor);
	miner_button.pressed.connect(_miner)
	smelter_button.pressed.connect(_smelter)
	foundry_button.pressed.connect(_foundry)
	constructor_button.pressed.connect(_constructor)
	manufacturer_button.pressed.connect(_manufacturer)


func _conveyor():
	sim_manager.selected_building = "conveyor_belt";
	sim_manager.create_building_preview()
	print("_conveyor called")
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
