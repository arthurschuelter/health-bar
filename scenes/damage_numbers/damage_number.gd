extends Label
class_name DamageNumber

@onready var label: Label = $Label
@onready var timer: Timer = $Timer

@export var waitTime: float = 1.2

# 1. Smooth print
@export var increaseTime: float = 0.8
var SPEED: float = 8 * waitTime / increaseTime
var shown: float
var target: int

# 2. Pop it in
@export var popTime: float = 0.4
var POP_SPEED: float = 8 * waitTime / popTime

# 3. Float upwards
var FLOAT_SPEED: float = 1.0
var targetY: float
var moveY: float = 30

# 4. Fade out
var fadeOutSpeed: float = 1.0

# 5. Fade out
var gravityForce: float = 500

# 6. Arc movement
var startingVelocity = Vector2(50, -120)
var velocity: Vector2

# 7. Size = damage
var maxScale = 1.2
var minScale = 0.75
var scaleFactor

# 8. Critical hit
var criticalHit: bool

func _ready() -> void:
	timer.wait_time = self.waitTime
	timer.start()

func _process(delta: float) -> void:
	smoothPrint(delta)
	popIn(delta)
	#floatUpwards(delta)
	fadeOut(delta)
	applyGravity(delta)
	
	move(delta)

func smoothPrint(dt: float):
	shown = lerpf(shown, float(target), SPEED * dt)
	if (target - shown < 0.1):
		shown = target
	
	self.text = "%s" % [int(self.shown)]
	
	if self.criticalHit:
		self.text += "!"

func popIn(dt: float) -> void:
	var scaleX = lerpf(self.scale.x, self.scaleFactor, POP_SPEED * dt)
	var scaleY = lerpf(self.scale.y, self.scaleFactor, POP_SPEED * dt)
	self.scale = Vector2(scaleX, scaleY)

func floatUpwards(dt: float) -> void:
	var posY = lerpf(self.global_position.y, targetY, FLOAT_SPEED * dt)
	self.global_position.y = posY

func fadeOut(dt: float) -> void:
	self.modulate.a -= fadeOutSpeed * dt

func applyGravity(dt: float) -> void:
	self.velocity.y += gravityForce * dt

func move(dt: float) -> void:
	self.position += velocity * dt

func Initialize(target: int, scale: float, direction: int, criticalHit: bool) -> void:
	self.target = target
	self.shown = 0
	
	self.scaleFactor = lerpf(
		minScale, 
		maxScale, 
		clampf(scale, 0.0, 1.0)
	)
	self.scale = Vector2(0, 0)
	
	self.targetY = self.global_position.y - moveY
	
	self.startingVelocity.x *= direction
	self.velocity = self.startingVelocity
	
	self.criticalHit = criticalHit
	
	if criticalHit:
		self.shown = target
		self.scaleFactor = maxScale

func _on_timer_timeout() -> void:
	queue_free()
