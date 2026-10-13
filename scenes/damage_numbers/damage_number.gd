extends Label

@onready var label: Label = $Label
@onready var timer: Timer = $Timer

var wait_time = 0.5

func _ready() -> void:
	timer.wait_time = self.wait_time
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
