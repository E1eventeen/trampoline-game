extends Node2D

var state : String
@export var c_top : CollisionShape2D
@export var c_bottom : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swap()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update() -> void:
	$AnimatedSprite2D.play(state)
	c_top.disabled = (state == "top")
	c_bottom.disabled = (state == "bottom")
	
func swap() -> void:
	var states = ["top", "bottom"]
	state = states.pick_random()
	update()
