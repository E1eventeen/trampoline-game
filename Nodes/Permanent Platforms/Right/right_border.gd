extends Node2D

var topDoorOpen = true
@export var b_top : AnimatableBody2D
@export var b_bottom : AnimatableBody2D
@export var particle : CPUParticles2D

const right := 1080.0
const left := 903.0
const speed := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if topDoorOpen:
		particle.position.y = 0
		
		
		if b_top.position.x < right:
			b_top.position.x += speed * delta
		else:
			b_top.get_child(1).disabled = true
		if b_bottom.position.x > left:
			b_bottom.position.x -= speed * delta
			b_bottom.get_child(1).disabled = false
	else:
		particle.position.y = 956
		
		if b_top.position.x > left:
			b_top.position.x -= speed * delta
			b_top.get_child(1).disabled = false
		if b_bottom.position.x < right:
			b_bottom.position.x += speed * delta
		else:
			b_bottom.get_child(1).disabled = true
	
	var precent = abs(right - b_top.position.x) / (right - left)
	$glow_b.self_modulate.a = precent * 0.5
	$glow_t.self_modulate.a = (1 - precent) * 0.5
	
	if precent >= 0 or precent <= 1:
		particle.emitting = true
	else:
		particle.emitting = false

func swap() -> void:
	topDoorOpen = !topDoorOpen


func _on_swap_timer_timeout() -> void:
	swap()
