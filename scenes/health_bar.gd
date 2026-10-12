extends Control

@onready var dummy: Dummy = %dummy

@onready var hp_value: Label = $HpValue
@onready var health_bar: ColorRect = %HealthBar
@onready var chunk_bar: ColorRect = %ChunkBar
@onready var flash_bar: ColorRect = %FlashBar

# Size and position
var maxWidth: int = 0
var startingPosition: Vector2

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


# Helpers
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	dummy.changeHealth.connect(updateHealthBar)
	maxWidth = health_bar.size.x
	startingPosition = self.position

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

func updateHealthBar(curHealth: int, maxHealth: int):
	self.curHealth = curHealth
	self.maxHealth = maxHealth
	
	chunkTimer = CHUNK_TIMER
	shakeTimer = SHAKE_DURATION
	flash_bar.color.a = 1
