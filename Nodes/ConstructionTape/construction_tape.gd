extends Node2D

var timeToDie := 3.0
var timeToDecay := 3.0
var decayElapsed : float
var decaying := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Kill Timer".wait_time = timeToDie
	$"Kill Timer".start()
	decayElapsed = timeToDecay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if decaying:
		decayElapsed -= delta
		$Sprite2D.self_modulate.a = (decayElapsed / timeToDecay) * 0.5
		if decayElapsed <= 0:
			queue_free()

func _on_kill_timer_timeout() -> void:
	decaying = true
