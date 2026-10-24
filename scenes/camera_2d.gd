extends Camera2D

@onready var dummy: Dummy = %dummy

var shakeAmount := 1.0
var shakeTimer := 0.0
var shakeDuration := 0.15
var startingPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dummy.shakeScreen.connect(startShake)
	startingPosition = self.position

	pass # Replace with function body.

func _process(dt: float) -> void:
	shakeTimer -= dt
	if shakeTimer >= 0:
		Animation2D.ShakeNode(self, shakeTimer, shakeAmount, shakeDuration)
	else:
		self.position = startingPosition

func startShake() -> void:
	shakeTimer = 0.15
