extends Control

@onready var dummy: Dummy = %dummy

@onready var hp_value: Label = $HpValue
@onready var health_bar: ColorRect = %HealthBar
@onready var chunk_bar: ColorRect = %ChunkBar
@onready var flash_bar: ColorRect = %FlashBar

# Size and position
var maxWidth: int = 0
var startingPosition: Vector2
var startingScale: Vector2

var curHealth: int = 100
var maxHealth: int = 100

# Health Bar Animation
var shown = curHealth
const LERP_SPEED: float = 12.0

# Chunk Animation
const CHUNK_TIMER: float = 0.4
var chunkShown = curHealth
var chunkTimer: float = 0

# Shake Animation
const SHAKE_DURATION: float = 0.15
var shakeAmount: float = 2
var shakeTimer: float  = 0

# Flash Animation
const FLASH_SPEED: float = 12.0

# Punch Animation
const PUNCH_DURATION: float = 0.15
var PUNCH_SPEED: float = -log(0.05) / PUNCH_DURATION
var punchAmount: float = 1.02
var punchTimer: float = 0

# 9. Color states
@export var color_high: Color
@export var color_mid: Color
@export var color_low: Color

# Helpers
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	dummy.changeHealth.connect(updateHealthBar)
	maxWidth = health_bar.size.x
	startingPosition = self.position
	startingScale = self.scale

func _process(dt: float):
	# 2. Smooth drain
	smoothHealthBar(dt)
	
	# 3. Damage chunk
	chunkTimer -= dt
	if chunkTimer <= 0:
		smoothChunkBar(dt)
	
	# 5. Shake animation
	shakeTimer -= dt
	if shakeTimer >= 0:
		shakeHealthBar()
	else:
		self.position = startingPosition
	
	# 6. Flash animation
	flashAnimation(dt)
	
	# 7. Punch animation
	punchTimer -= dt
	if punchTimer >= 0:
		punchAnimation(dt)
	else:
		scale = startingScale
		
	# 9. Color states:
	healthColorState()

func smoothHealthBar(dt: float):
	shown = lerpf(shown, float(curHealth), LERP_SPEED * dt)
	health_bar.size.x = maxWidth * float(shown) / maxHealth
	
	if (maxHealth - shown < 0.1):
		shown = maxHealth
	
	hp_value.text = "%s/%s" % [int(shown), maxHealth]

func smoothChunkBar(dt: float):
	chunkShown = lerpf(chunkShown, float(curHealth), LERP_SPEED * 0.7 * dt)
	chunk_bar.size.x = maxWidth * float(chunkShown) / maxHealth

func shakeHealthBar():
	var shakeStrength: float = shakeAmount * (shakeTimer / SHAKE_DURATION)
	
	self.position = startingPosition + Vector2(
		rng.randf_range(-shakeStrength, shakeStrength),
		rng.randf_range(-shakeStrength, shakeStrength)
	)

func flashAnimation(dt: float):
	if flash_bar.color.a > 0:
		flash_bar.color.a -= dt * FLASH_SPEED

func punchAnimation(dt: float):
	var x = lerpf(scale.x, startingScale.x, PUNCH_SPEED * dt)
	var y = lerpf(scale.y, startingScale.y, PUNCH_SPEED * dt)
	self.scale = Vector2(x, y)

func healthColorState():
	var ratio: float = float(self.curHealth) / self.maxHealth
	print(ratio)
	if ratio > 0.5:
		health_bar.color = color_high
	elif ratio > 0.25:
		health_bar.color = color_mid
	else:
		health_bar.color = color_low

func updateHealthBar(curHealth: int, maxHealth: int):
	self.curHealth = curHealth
	self.maxHealth = maxHealth
	
	chunkTimer = CHUNK_TIMER
	shakeTimer = SHAKE_DURATION
	flash_bar.color.a = 1
	
	punchTimer = PUNCH_DURATION
	self.scale = Vector2(punchAmount, punchAmount)
