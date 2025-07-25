extends Node

@export var b_left : Node2D
@export var b_right : Node2D
var Ball := preload("res://Nodes/Ball/ball2.tscn")
var activeBall : Node2D

var Trampoline := preload("res://Nodes/Trampoline/Trampoline.tscn")
var trampolines := []
var trampolineLimit := 3
var count = 0

var score := 0
@export var l_score : Label

var mousePos : Vector2
var mousePressed := false
var mouseOrigin : Vector2

const ballScaleVariance := 0.1

var ballQueue := []

var gameState = "title"

func _ready() -> void:
	pass
	
func play() -> void:
	gameState = "playing"
	$"Title Layer".visible = false
	print("g")
	$BallSpawnEvent.start()
	
	
func generateBall():
	activeBall = Ball.instantiate()
	activeBall.updateScale(Vector2.ONE * randf_range(1 - ballScaleVariance, 1 + ballScaleVariance))
	activeBall.connect("passRight", ballPassRight)
	activeBall.connect("passBottom", ballPassBottom)
	activeBall.winBoundX = get_viewport().get_visible_rect().size.x
	activeBall.position = Vector2(get_viewport().get_visible_rect().size.x / 2.0, -activeBall.offsetSize)
	activeBall.apply_central_force(Vector2(randi_range(-5000, 5000), 0))
	
	activeBall.rotation = deg_to_rad(randi() * 360.0)
	activeBall.angular_velocity = randf_range(-1, 1)
	
	if ballQueue.is_empty():
		for i in range(activeBall.getFrameCount()):
			ballQueue.append(i)
		ballQueue.shuffle()
		
	if len(ballQueue) == 1:
		for i in range(activeBall.getFrameCount()):
			ballQueue.append(i)
		if ballQueue[0] == ballQueue[1]:
			var temp = ballQueue[1]
			ballQueue[1] = ballQueue[2]
			ballQueue[2] = temp
	
	activeBall.setTexture(ballQueue.pop_front())
	
	$"Play Layer".add_child(activeBall)
	
func _process(delta: float) -> void:
	
	mousePos = $"Play Layer/GUI".get_global_mouse_position()
	
	var window_size = get_viewport().get_visible_rect().size
	b_right.position.x = window_size.x - 1080
	$"Play Layer/ForceBox2".position.x = window_size.x - 177
		
	if Input.is_action_just_pressed("press"):
		if !mousePressed:
			mousePressed = true
			mouseOrigin = mousePos
			
			if trampolines.size() >= trampolineLimit:
				trampolines[0].destroy()
				
			var newTrampoline = load("res://Nodes/Trampoline/Trampoline.tscn").instantiate()
			
			if mouseOrigin.x < 165: #Block too far left starts
				mouseOrigin.x = 165
			if mouseOrigin.x > window_size.x - 165:
				mouseOrigin.x = window_size.x - 165
				
			if mouseOrigin.y < 1500:
				if mouseOrigin.y > 1400:
					mouseOrigin.y = 1500
				else:
					return
			
			newTrampoline.setStart(mouseOrigin)
			newTrampoline.ID = count
			count += 1
			
			$"Play Layer".add_child(newTrampoline)
			$"Play Layer".move_child(newTrampoline, 0)
			trampolines.append(newTrampoline)
			
	if Input.is_action_pressed("press"):
		if mousePressed:
			if getTrampoline():
				
				if mousePos.x < 165: #Block too far left starts
					mousePos.x = 165
				if mousePos.x > window_size.x - 165:
					mousePos.x = window_size.x - 165
				
				if mousePos.y < 1500:
					mousePos.y = 1500
				
				getTrampoline().update(mousePos)
	else:
		mousePressed = false
		if getTrampoline():
			getTrampoline().lock()
	
	for ball in get_tree().get_nodes_in_group("balls"):
		if Input.is_action_pressed("middle"):
			ball.linear_velocity = Vector2(0, 0)
			ball.position = mousePos
		
		continue
		print("N")
		if abs(ball.linear_velocity.x) < 50:
			if ball.position.x > window_size.x - 165 - ball.offsetSize or ball.position.x < 165 + ball.offsetSize:
				ball.apply_central_force(Vector2(200, 0))
	
func getTrampoline() -> Node2D:
	for trampoline in trampolines:
		if trampoline.drawing:
			return trampoline
	return null

func destroyTrampoline(trampoline):
	trampolines.erase(trampoline)
			
func ballPassRight(ball: RigidBody2D):
	score += 1
	l_score.text = "Score: " + str(score)
	remove_child(ball)
	ball.queue_free()
	
func ballPassBottom(ball: RigidBody2D):
	score = 0
	l_score.text = "Score: " + str(score)
	
	for killBall in get_tree().get_nodes_in_group("balls"):
		remove_child(ball)
		ball.queue_free()
		ballSpawnAttempt()
	
func ballSpawnAttempt() -> void:
	const ballSpawnLimits = {30:4, 15:3, 5:2, 0:1}
	
	var activeBalls = get_tree().get_nodes_in_group("balls").size()
	
	for spawnLimit in ballSpawnLimits:
		if score >= spawnLimit:
			if activeBalls < ballSpawnLimits[spawnLimit]:
				generateBall()
				$BallSpawnEvent.wait_time = 3
			else:
				$BallSpawnEvent.wait_time = 1
				
			$BallSpawnEvent.start()
			return
			
	$BallSpawnEvent.start()
	
