class_name Trampoline extends StaticBody2D

var start := Vector2(0, 0)
var end := Vector2(0, 0)
var size : float
var ID : int

const minSize = 100.0

var drawing = true

@export var collision : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setStart(initial := Vector2(0, 0)) -> void:
	start = initial
	collision.shape.a = start

func update(current : Vector2) -> void:
	drawing = true
	$Texture.self_modulate = Color.RED
	#$CollisionShape2D.disabled = true
	
	end = current
	size = start.distance_to(end)
	
	collision.shape.b = end
	
	$Texture.position = (start + end) / 2.0
	$Texture.rotation = start.angle_to_point(end)
	$Texture.scale.x = size / $Texture.texture.get_width()
	$Texture.scale.y = size / $Texture.texture.get_height() / 10
	
func lock() -> void:
	drawing = false
	$CollisionShape2D.disabled = false
	$Texture.self_modulate = Color.WHITE
	
	if size < minSize:
		destroy()

func destroy():
	get_parent().get_parent().removeTrampoline(ID)
