extends Node

@onready var marker_2d: Marker2D = $Marker2D
@onready var dmg_number_scene: PackedScene = preload("res://scenes/damage_numbers/damage_number.tscn")
@onready var dummy: Dummy = %dummy

func _ready() -> void:
	dummy.spawnDamage.connect(Spawn)

func Spawn(damage_value: int):
	var dmg: Label = dmg_number_scene.instantiate()
	dmg.global_position = marker_2d.position
	dmg.text = str(damage_value)
	add_child(dmg)
