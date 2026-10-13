extends Node2D
class_name Dummy


var rng = RandomNumberGenerator.new()
var minDamage: int = 5
var maxDamage: int = 15
var critChance: float = 0.16

var curHealth: int = 100
var maxHealth: int = 100

var mouseEntered: bool = false
signal changeHealth
signal spawnDamage

func _input(event: InputEvent):
	handleMouse(event)

func handleMouse(event: InputEvent):
	if event is InputEventMouseButton and mouseEntered and event.is_pressed():
		var dmg = rng.randi_range(minDamage, maxDamage)
		var crit: bool = rng.randf() <= critChance
		
		if crit:
			dmg *= 2
		
		curHealth -= dmg
		if curHealth <= 0:
			curHealth = maxHealth
		
		changeHealth.emit(curHealth, maxHealth)
		spawnDamage.emit(dmg, minDamage, maxDamage, crit)

func _on_dummy_mouse_entered() -> void:
	mouseEntered = true

func _on_dummy_mouse_exited() -> void:
	mouseEntered = false
