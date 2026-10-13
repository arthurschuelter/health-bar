extends Node

@onready var marker_2d: Marker2D = $Marker2D
@onready var dmg_number_scene: PackedScene = preload("res://scenes/damage_numbers/damage_number.tscn")
@onready var dummy: Dummy = %dummy

var direction: int = 1

func _ready() -> void:
	dummy.spawnDamage.connect(Spawn)

func Spawn(damageValue: int, minDamage:int, maxDamage: int, criticalHit: bool):
	var dmg: DamageNumber = dmg_number_scene.instantiate()
	dmg.global_position = marker_2d.global_position
	
	var scale: float = float(damageValue - minDamage) / float(maxDamage - minDamage)
	
	dmg.Initialize(damageValue, scale, direction, criticalHit)
	direction *= -1
	add_child(dmg)
