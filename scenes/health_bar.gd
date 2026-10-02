extends Control

@onready var dummy: Dummy = %dummy

@onready var hp_value: Label = $HpValue
@onready var health_bar: ColorRect = %HealthBar
@onready var chunk_bar: ColorRect = %ChunkBar

var maxWidth: int = 0

var curHealth: int = 100
var maxHealth: int = 100
var shown = curHealth
var chunkShown = curHealth

const LERP_SPEED: float = 12.0

const CHUNK_TIMER: float = 0.4
var chunkTimer: float = 0

func _ready() -> void:
	dummy.changeHealth.connect(updateHealthBar)
	maxWidth = health_bar.size.x
	
func _process(dt: float):
	# 2. Smooth drain
	smoothHealthBar(dt)
	
	# 3. Damage chunk
	chunkTimer -= dt
	if chunkTimer <= 0:
		smoothChunkBar(dt)

func smoothHealthBar(dt):
	shown = lerpf(shown, float(curHealth), LERP_SPEED * dt)
	health_bar.size.x = maxWidth * float(shown) / maxHealth
	
	hp_value.text = "%s/%s" % [int(shown), maxHealth]

func smoothChunkBar(dt):
	chunkShown = lerpf(chunkShown, float(curHealth), LERP_SPEED * 0.7 * dt)
	chunk_bar.size.x = maxWidth * float(chunkShown) / maxHealth

func updateHealthBar(curHealth: int, maxHealth: int):
	self.curHealth = curHealth
	self.maxHealth = maxHealth
	
	chunkTimer = CHUNK_TIMER
	
