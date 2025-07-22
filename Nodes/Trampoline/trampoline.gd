class_name Trampoline extends StaticBody2D

var start := Vector2(0, 0)
var end := Vector2(0, 0)
var size : float
var ID : int

const minSize = 100.0
const specialBounceSize = 200.0

var drawing := true
var falling := false
var vY := 100.0

@export var collisionLine : CollisionShape2D
@export var collisionBox : CollisionShape2D
@export var bumperA : Sprite2D
@export var bumperB : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if falling:
		$Texture.self_modulate.a -= delta
		
		bumperA.self_modulate = $Texture.self_modulate
		bumperB.self_modulate = $Texture.self_modulate
		
		position.y += delta * vY
		vY += delta * 300.0
		
		if $Texture.self_modulate.a <= 0.0:
			queue_free()
	
func setStart(initial := Vector2(0, 0)) -> void:
	start = initial
	collisionLine.shape.a = start
	bumperA.position = start
	
	$Texture.scale.y = $Texture.texture.get_height() / 200.0
	bumperA.scale = Vector2.ONE * $Texture.scale.y
	bumperB.scale = Vector2.ONE * $Texture.scale.y

func update(current : Vector2) -> void:
	drawing = true

	#$CollisionShape2D.disabled = true
	
	end = current
	size = start.distance_to(end)
	
	if size > minSize:
		$Texture.self_modulate = Color.GRAY
		$Texture.self_modulate.a = 0.75
	else:
		$Texture.self_modulate = Color.LIGHT_GRAY
		$Texture.self_modulate.a = 0.2
	
	collisionLine.shape.b = end
	
	$Texture.position = (start + end) / 2.0
	$Texture.rotation = start.angle_to_point(end)
	$Texture.scale.x = size / $Texture.texture.get_width()
	
	collisionBox.transform = $Texture.transform
	
	bumperA.self_modulate = $Texture.self_modulate
	bumperB.self_modulate = $Texture.self_modulate
	bumperB.position = current
	
func lock() -> void:
	drawing = false
	collisionBox.disabled = false
	
	if size < specialBounceSize:
		$Texture.self_modulate = Color.LIGHT_SALMON
	else:
		$Texture.self_modulate = Color.WHITE
		
	bumperA.self_modulate = $Texture.self_modulate
	bumperB.self_modulate = $Texture.self_modulate
	
	if size < minSize:
		destroy()

func destroy(broken := false):
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	get_parent().get_parent().destroyTrampoline(self)
	if broken:
		falling = true
	else:
		queue_free()
	
