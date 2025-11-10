extends Control


@onready var sim_manager = $"../../SimManager";

@onready var conveyor_r_button = $HBoxContainer/ConveyorButtonR;
@onready var conveyor_l_button = $HBoxContainer/ConveyorButtonL;
@onready var conveyor_u_button = $HBoxContainer/ConveyorButtonU;
@onready var conveyor_d_button = $HBoxContainer/ConveyorButtonD;

@onready var miner_button = $HBoxContainer/MinerButton;
@onready var smelter_button = $HBoxContainer/SmelterButton;
@onready var foundry_button = $HBoxContainer/FoundryButton;
@onready var constructor_button = $HBoxContainer/ConstructorButton;
@onready var manufacturer_button = $HBoxContainer/ManufacturerButton;


func _ready():
	conveyor_r_button.pressed.connect(_conv_r);
	conveyor_l_button.pressed.connect(_conv_l);
	conveyor_u_button.pressed.connect(_conv_u);
	conveyor_d_button.pressed.connect(_conv_d);
	
	miner_button.pressed.connect(_miner)


func _conv_r():
	sim_manager.selected_building = "conveyor_right";
	sim_manager.create_building_preview()
func _conv_l():
	sim_manager.selected_building = "conveyor_left";
	sim_manager.create_building_preview()
func _conv_u():
	sim_manager.selected_building = "conveyor_up";
	sim_manager.create_building_preview()
func _conv_d():
	sim_manager.selected_building = "conveyor_down";
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
