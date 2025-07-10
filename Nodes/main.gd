extends Node

@export var b_left : Node2D
@export var b_right : Node2D
var Ball := preload("res://Nodes/Ball/ball.tscn")
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
	
func generateBall():
	if activeBall:
		$"Play Layer".remove_child(activeBall)
		activeBall.queue_free()
	activeBall = Ball.instantiate()
	#activeBall.scale = Vector2.ONE * 0.5
	activeBall.setPosition(Vector2(200, 200))
	$"Play Layer".add_child(activeBall)
	
func _process(delta: float) -> void:
	
	mousePos = $"Play Layer/GUI".get_global_mouse_position()
	
	var window_size = get_viewport().get_visible_rect().size
	b_right.position.x = window_size.x - 1080

	if activeBall.rbPosition.y > (window_size.y / activeBall.scale.y) + activeBall.offsetSize * 1.5:
		score = 0
		l_score.text = "Score: " + str(score)
		generateBall()
		
	if activeBall.rbPosition.x > (window_size.x / activeBall.scale.x) + activeBall.offsetSize * 1.5:
		b_right.swap()
		score += 1
		l_score.text = "Score: " + str(score)
		generateBall()
		
	if Input.is_action_just_pressed("press"):
		if !mousePressed:
			mousePressed = true
			mouseOrigin = mousePos
			
			if trampolines.size() >= trampolineLimit:
				removeTrampoline(trampolines[0].ID)
				
			var newTrampoline = load("res://Nodes/Trampoline/Trampoline.tscn").instantiate()
			newTrampoline.setStart(mouseOrigin)
			newTrampoline.ID = count
			count += 1
			$"Play Layer".add_child(newTrampoline)
			trampolines.append(newTrampoline)
			
	if Input.is_action_pressed("press"):
		if mousePressed:
			if getTrampoline():
				getTrampoline().update(mousePos)
	else:
		mousePressed = false
		if getTrampoline():
			getTrampoline().lock()
			
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
