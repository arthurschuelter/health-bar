extends Control

@onready var dummy: Dummy = %dummy

@onready var hp_value: Label = $HpValue
@onready var health_bar: ColorRect = %HealthBar

var maxWidth: int = 0
var maxHeight: int = 0

func _ready() -> void:
	dummy.changeHealth.connect(updateHealthBar)
	maxWidth = health_bar.size.x
	maxHeight = health_bar.size.y

func updateHealthBar(curHealth: int, maxHealth: int):
	var ratio: float = float(curHealth) / maxHealth
	
	hp_value.text = "%s/%s" % [curHealth, maxHealth]
	health_bar.size = Vector2(maxWidth * ratio, maxHeight)
	
