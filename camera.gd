extends Camera2D

@export var speed = 5;

var velocity = 0.0;

func _physics_process(_delta: float):
	
	velocity = Vector2.ZERO;
	
	if (Input.is_action_pressed("move_right")) and position.x < 100:
		velocity.x += 1;
	if (Input.is_action_pressed("move_left")):
		velocity.x -= 1;
	if (Input.is_action_pressed("move_up")):
		velocity.y -= 1;
	if (Input.is_action_pressed("move_down")):
		velocity.y += 1;
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		position += velocity
	
	if Input.is_action_just_pressed("zoom1"):
		zoom = Vector2(10, 10);
	if Input.is_action_just_pressed("zoom2"):
		zoom = Vector2(5, 5);
	if Input.is_action_just_pressed("zoom3"):
		zoom = Vector2(2, 2);
	if Input.is_action_just_pressed("zoom4"):
		zoom = Vector2(0.5, 0.5);
