extends Area2D

@export var force := 1000.0
@export var forceDirection := Vector2(1, 0)
var holding := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for object in holding:
		object.apply_central_force(forceDirection * force)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	holding.append(body)

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	holding.erase(body)
