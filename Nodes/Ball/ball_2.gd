class_name Ball extends RigidBody2D

var offsetSize : float

var minVelocityBounce := 1000.0
var maxVelocityBounce := 2500.0
var maxSize := 500.0 #Max size of trampoline

var normalBounce := true

var winBoundX := 1080 # Bound where ball "Wins"
var loseBoundY := 2400 # Bound where ball "Loses"

var manualScale := Vector2.ONE

var sparkling := false
var sparkleBounceSpeed := 10000.0

signal passRight(sender : RigidBody2D)
signal passBottom(sender : RigidBody2D)

var muted := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.x > winBoundX + offsetSize:
		passRight.emit(self)
	if position.y > loseBoundY + offsetSize:
		passBottom.emit(self)
	
	if sparkling:
		if linear_velocity.length() < sparkleBounceSpeed or linear_velocity.y > 0:
			#print("ending sparkle")
			sparkling = false
			$GPUParticles2D.emitting = false
		else:
			$GPUParticles2D.emitting = true

	if position.y > offsetSize:
		set_collision_mask_value(3, true)

func collision(body: Node) -> void:
	if body is Trampoline:
		
		if !muted:
			$AudioStreamPlayer.pitch_scale = randf_range(-0.2, 0.2) + 1
			$AudioStreamPlayer.play()
		
		var launchVelocity = minVelocityBounce
		if body.size < maxSize:
			if body.size < body.specialBounceSize:
				launchVelocity = 2500.0
				sparkling = true
			else:
				launchVelocity += (maxVelocityBounce - minVelocityBounce) * (1.0 - (body.size / maxSize))
			
		
		if normalBounce:
			var launchAngle = (body.start - body.end).normalized().rotated(PI/2)
			if launchAngle.y > 0: launchAngle = launchAngle.rotated(PI)
			#linear_velocity = launchAngle * launchVelocity
			linear_velocity *= 0.1
			apply_central_force(launchAngle * launchVelocity * 30.0)
		else:
			linear_velocity = linear_velocity.normalized() * launchVelocity
			
		linear_velocity.y = clampf(linear_velocity.y, -5000.0, 5000.0)
		
		if sparkling:
			sparkleBounceSpeed = linear_velocity.length()
			#print(sparkleBounceSpeed)
	
		body.destroy()
		

func updateScale(newScale := Vector2.ONE):
	manualScale = newScale
	$Sprite2D.scale = manualScale
	$CollisionShape2D.scale = manualScale
	offsetSize = scale.x * 100.0 * 1.5
