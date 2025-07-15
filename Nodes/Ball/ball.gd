extends Node2D

var rbPosition : Vector2
var offsetSize := scale.x + 100.0

var minVelocity := 500.0
var maxVelocity := 1500.0
var maxSize := 1000.0

const normalBounce := false

func _ready() -> void:
	
	offsetSize = scale.x + 50.0
	
	# Update scale of RigidBody to match that of Node2D
	$RigidBody2D/Sprite2D.scale = scale
	$RigidBody2D/CollisionShape2D.scale = scale
	
	$RigidBody2D.apply_impulse(Vector2(randf_range(100, 500), -300))
	visible = true
	
func setPosition(pos: Vector2):
	# Lock initial position to 2D position
	$RigidBody2D.position = pos


func _process(delta: float) -> void:
	rbPosition = $RigidBody2D.position

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
