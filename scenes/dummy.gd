extends Node2D
class_name Dummy

@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer

# Damage values
var rng = RandomNumberGenerator.new()
var minDamage: int = 3
var maxDamage: int = 10
var critChance: float = 0.16

# Health state
var curHealth: int = 100
var maxHealth: int = 100

# Mouse input
var mouseEntered: bool = false

# Hit animation
var scaleSpeed: float = 10
var minScale = Vector2(0.6, 0.6)

# Signals
signal changeHealth
signal spawnDamage

func _input(event: InputEvent):
	handleMouse(event)

func _process(delta: float):
	scaleBack(delta)

func scaleBack(dt: float):
	var scaleX = lerpf(self.scale.x, 1.0, scaleSpeed * dt)
	var scaleY = lerpf(self.scale.y, 1.0, scaleSpeed * dt)
	self.scale = Vector2(scaleX, scaleY)

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
		playHitSfx(crit)
		
		self.scale = minScale

func playHitSfx(criticalHit: bool):
	var pitch: float = rng.randf_range(0.75, 1.20)
	sfx_player.pitch_scale = pitch
	if criticalHit:
		sfx_player.pitch_scale = 0.40
	sfx_player.play()

func _on_dummy_mouse_entered() -> void:
	mouseEntered = true

func _on_dummy_mouse_exited() -> void:
	mouseEntered = false
