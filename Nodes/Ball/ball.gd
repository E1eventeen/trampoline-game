extends Node2D

var rbPosition : Vector2
var offsetSize := scale.x + 100.0

var minVelocity := 1000.0
var maxVelocity := 2000.0
var maxSize := 1000.0

const normalBounce := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RigidBody2D/Sprite2D.scale = scale
	$RigidBody2D/CollisionShape2D.shape.radius = 100 * scale.x
	
func setPosition(pos: Vector2):
	$RigidBody2D.position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rbPosition = $RigidBody2D.position
	offsetSize = scale.x + 50.0

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body is Trampoline:
		var launchVelocity = minVelocity
		if body.size < maxSize:
			launchVelocity += (maxVelocity - minVelocity) * (1.0 - (body.size / maxSize))
		
		if normalBounce:
			var launchAngle = (body.start - body.end).normalized().rotated(PI/2)
			if launchAngle.y > 0: launchAngle = launchAngle.rotated(PI)
			$RigidBody2D.linear_velocity = launchAngle * launchVelocity
		else:
			$RigidBody2D.linear_velocity = Vector2($RigidBody2D.linear_velocity).normalized() * launchVelocity
	
		body.destroy()
