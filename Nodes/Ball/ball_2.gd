class_name Ball extends RigidBody2D

var offsetSize := scale.x + 100.0

var minVelocityBounce := 1000.0
var maxVelocityBounce := 2500.0
var maxSize := 1000.0 #Max size of trampoline

var normalBounce := true

var winBoundX := 1080 # Bound where ball "Wins"
var loseBoundY := 2400 # Bound where ball "Loses"

signal passRight(sender : RigidBody2D)
signal passBottom(sender : RigidBody2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.x > winBoundX + offsetSize:
		passRight.emit(self)
	if position.y > loseBoundY + offsetSize:
		passBottom.emit(self)
	

func collision(body: Node) -> void:
	if body is Trampoline:
		var launchVelocity = minVelocityBounce
		if body.size < maxSize:
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
	
		body.destroy()
		
