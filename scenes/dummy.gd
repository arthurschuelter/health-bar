extends Node2D
class_name Dummy


var rng = RandomNumberGenerator.new()
var curHealth: int = 100
var maxHealth: int = 100

var mouseEntered: bool = false
signal changeHealth

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent):
	handleMouse(event)

func handleMouse(event: InputEvent):
	if event is InputEventMouseButton and mouseEntered and event.is_pressed():
		curHealth -= rng.randi_range(5, 15)
		if curHealth <= 0:
			curHealth = maxHealth
		changeHealth.emit(curHealth, maxHealth)

func _on_dummy_mouse_entered() -> void:
	mouseEntered = true

func _on_dummy_mouse_exited() -> void:
	mouseEntered = false
