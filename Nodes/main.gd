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

func _ready() -> void:
	generateBall()
	await get_tree().create_timer(3).timeout
	generateBall()
	await get_tree().create_timer(5).timeout
	generateBall()
	
func generateBall():
	activeBall = Ball.instantiate()
	activeBall.connect("passRight", ballPassRight)
	activeBall.connect("passBottom", ballPassBottom)
	activeBall.winBoundX = get_viewport().get_visible_rect().size.x
	activeBall.position = Vector2(200, 200)
	$"Play Layer".add_child(activeBall)
	
func _process(delta: float) -> void:
	
	mousePos = $"Play Layer/GUI".get_global_mouse_position()
	
	var window_size = get_viewport().get_visible_rect().size
	b_right.position.x = window_size.x - 1080
		
	if Input.is_action_just_pressed("press"):
		if !mousePressed:
			mousePressed = true
			mouseOrigin = mousePos
			
			if trampolines.size() >= trampolineLimit:
				removeTrampoline(trampolines[0].ID)
				
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
		if ball.position.x > window_size.x - 165:
			ball.apply_central_force(Vector2(100, 0))
	
func getTrampoline() -> Node2D:
	for trampoline in trampolines:
		if trampoline.drawing:
			return trampoline
	return null

func removeTrampoline(ID: int):
	for t in trampolines:
		if t.ID == ID:
			trampolines.erase(t)
			$"Play Layer".remove_child(t)
			t.queue_free()
			
func ballPassRight(ball: RigidBody2D):
	b_right.swap()
	score += 1
	l_score.text = "Score: " + str(score)
	remove_child(ball)
	ball.queue_free()
	generateBall()
	
func ballPassBottom(ball: RigidBody2D):
	score = 0
	l_score.text = "Score: " + str(score)
	remove_child(ball)
	ball.queue_free()
	generateBall()
