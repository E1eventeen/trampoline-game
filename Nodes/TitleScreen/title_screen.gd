extends Control

var tick = 0.0
const floatSpeeds := Vector2(0.5, 1)
const floatDistances := Vector2(10,10)

const fadeSpeed := 1.0

@export var Logo : TextureRect
@export var StartButton : TextureButton

var buttonSet = false
var fading = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if fading:
		modulate.a -= delta * fadeSpeed
		if modulate.a <= 0.0:
			get_parent().get_parent().play()
			fading = false
			modulate.a = 1
	
	tick += delta
	Logo.position = Vector2(cos(tick * floatSpeeds.x), sin(tick * floatSpeeds.y)) * floatDistances
	StartButton.position = Vector2(cos(tick * floatSpeeds.x + 3), sin(tick * floatSpeeds.y + 1)) * floatDistances


func _on_start_button_button_up() -> void:
	fading = true
