extends Node2D

var muted := false
var mouseEntered := false
var fading := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateFrame()
	$FadeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("press"):
		if mouseEntered:
			fading = false
			muted = !muted
			updateFrame()
			modulate.a = 1
			$FadeTimer.start()
			
	if fading and modulate.a > 0.25:
		modulate.a -= delta / 4
			
			
func updateFrame() -> void:
	if muted:
		$AnimatedSprite2D.frame = 0
	else:
		$AnimatedSprite2D.frame = 1

func _on_area_2d_mouse_entered() -> void:
	mouseEntered = true
	
func _on_area_2d_mouse_exited() -> void:
	mouseEntered = false
	
func _on_fade_timer_timeout() -> void:
	fading = true
