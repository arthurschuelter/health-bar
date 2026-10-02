extends Node

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180
const RECT_SIZE: int = 16
const PERIOD: int = RECT_SIZE * 2

const COLOR_1: Color = Color(0.69, 0.69, 0.69, 0.3)
const COLOR_2: Color = Color(0.235, 0.235, 0.235, 0.3)

var velocity := Vector2(8, 8)
var offset := Vector2.ZERO
var container := Node2D.new()

func _ready() -> void:
	add_child(container)
	var cols := ceili((SCREEN_WIDTH + PERIOD) / float(RECT_SIZE))
	var rows := ceili((SCREEN_HEIGHT + PERIOD) / float(RECT_SIZE))

	for x in cols:
		for y in rows:
			container.add_child(instantiateColorRect(x, y))

func _process(delta: float) -> void:
	offset += velocity * delta
	offset.x = fposmod(offset.x, PERIOD)
	offset.y = fposmod(offset.y, PERIOD)
	container.position = (offset - Vector2(PERIOD, PERIOD))

func instantiateColorRect(x: int, y: int) -> ColorRect:
	var colorRect := ColorRect.new()
	colorRect.size = Vector2(RECT_SIZE, RECT_SIZE)
	colorRect.position = Vector2(x, y) * RECT_SIZE
	colorRect.z_index = -1
	colorRect.color = COLOR_1 if (x + y) % 2 == 0 else COLOR_2
	return colorRect
