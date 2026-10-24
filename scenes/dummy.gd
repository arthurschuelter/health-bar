extends Node2D
class_name Dummy

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer
@export var hitHurtSfx: AudioStream
@export var deathSfx: AudioStream
var masterBus = "Master"
var pitchShiftBus = "PitchShift"

var flash_tween: Tween

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

# Respawn
@onready var respawnTimer: Timer = $RespawnTimer
@onready var deadSprite: Sprite2D = $DeadSprite
var isDead: bool = false
var rotationDegrees: int = 90
var animationOffset: int = 30
var spawnPoint: Vector2 = Vector2(0,0)
var initialSpriteScale: Vector2 = Vector2(0,0)
var deathTween: Tween
var respawnTween: Tween

# Signals
signal changeHealth
signal spawnDamage
signal shakeScreen

func _ready() -> void:
	sprite_2d.material = sprite_2d.material.duplicate()
	deadSprite.material = deadSprite.material.duplicate()
	deadSprite.visible = false
	
	initialSpriteScale = sprite_2d.scale

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
		if isDead:
			return
		
		var clickPosition: Vector2 = event.position
		var dmg = rng.randi_range(minDamage, maxDamage)
		var crit: bool = rng.randf() <= critChance
		var audioStream: AudioStream = hitHurtSfx
		
		if crit:
			dmg *= 2
		
		curHealth = max(curHealth - dmg, 0)
		if curHealth <= 0:
			audioStream = deathSfx
			Animation2D.DeathParticles(self, self.global_position)
			die()
		
		changeHealth.emit(curHealth, maxHealth)
		spawnDamage.emit(dmg, minDamage, maxDamage, crit)
		shakeScreen.emit()
		Animation2D.HitParticles(sprite_2d, clickPosition)
		playHitSfx(audioStream, crit)
		hitFlash()
		
		self.scale = minScale

func playHitSfx(audioStream: AudioStream, criticalHit: bool):
	var pitch: float = rng.randf_range(0.75, 1.10)
	sfx_player.stream = audioStream
	sfx_player.pitch_scale = pitch
	
	if criticalHit:
		sfx_player.pitch_scale = 1
		sfx_player.bus = pitchShiftBus
	sfx_player.play()
	sfx_player.bus = masterBus

	
func hitFlash(duration: float = 0.25) -> void:
	if flash_tween:
		flash_tween.kill()
	var mat := sprite_2d.material as ShaderMaterial
	mat.set_shader_parameter("flash_amount", 1.0)
	flash_tween = create_tween()
	flash_tween.tween_property(mat, "shader_parameter/flash_amount", 0.0, duration)

func die() -> void:
	respawnTimer.start(0.5)
	isDead = true
	
	sprite_2d.visible = false
	var randomDirection = 1 if rng.randf() < 0.5 else -1
	deathTween = Animation2D.DeathAnimation(
		deadSprite, 
		spawnPoint, 
		rotationDegrees * randomDirection, 
		initialSpriteScale, 
		animationOffset * randomDirection
	)

func respawn() -> void:
	isDead = false
	curHealth = maxHealth
	changeHealth.emit(curHealth, maxHealth)
	
	deadSprite.visible = false
	
	if respawnTween:
		respawnTween.kill()
	respawnTween = Animation2D.RespawnAnimation(sprite_2d, initialSpriteScale)

func _on_dummy_mouse_entered() -> void:
	mouseEntered = true

func _on_dummy_mouse_exited() -> void:
	mouseEntered = false

func _on_respawn_timer_timeout() -> void:
	respawn()
