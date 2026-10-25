# Health Bar
Project used to practice adding visual and sound effects to game mechanics.
The goal is to have a satisfactory gameplay, even without complex mechanics. 

Available at: https://tururuca.itch.io/health-bar-prototype

## _Health Bar._
1. Smooth drain.
``` GDScript
var shown = curHealth
const LERP_SPEED: float = 12.0

func smoothHealthBar(dt: float):
	shown = lerpf(shown, float(curHealth), LERP_SPEED * dt)
	health_bar.size.x = maxWidth * float(shown) / maxHealth
	
	if (maxHealth - shown < 0.1):
		shown = maxHealth
	
	hp_value.text = "%s/%s" % [int(shown), maxHealth]
```

2. Damage chunk.
``` GDScript
const LERP_SPEED: float = 12.0
const CHUNK_TIMER: float = 0.4
var chunkShown = curHealth
var chunkTimer: float = 0

func smoothChunkBar(dt: float):
	chunkShown = lerpf(chunkShown, float(curHealth), LERP_SPEED * 0.7 * dt)
	chunk_bar.size.x = maxWidth * float(chunkShown) / maxHealth
```

3. Add shake.
``` GDScript
const SHAKE_DURATION: float = 0.15
var shakeAmount: float = 2
var shakeTimer: float  = 0

func shakeHealthBar():
	var shakeStrength: float = shakeAmount * (shakeTimer / SHAKE_DURATION)
	
	self.position = startingPosition + Vector2(
		rng.randf_range(-shakeStrength, shakeStrength),
		rng.randf_range(-shakeStrength, shakeStrength)
	)
```

4. Add flash.
```GDScript
const FLASH_SPEED: float = 12.0

func flashAnimation(dt: float):
	if flash_bar.color.a > 0:
		flash_bar.color.a -= dt * FLASH_SPEED
```


5. Add punch.
```GDScript
const PUNCH_DURATION: float = 0.15
var PUNCH_SPEED: float = -log(0.05) / PUNCH_DURATION
var punchAmount: float = 1.02
var punchTimer: float = 0

func punchAnimation(dt: float):
	var x = lerpf(scale.x, startingScale.x, PUNCH_SPEED * dt)
	var y = lerpf(scale.y, startingScale.y, PUNCH_SPEED * dt)
	self.scale = Vector2(x, y)
```

6. Damage numbers.

```GDScript
func Spawn(damage_value: int):
	var dmg: Label = dmg_number_scene.instantiate()
	dmg.global_position = marker_2d.global_position
	dmg.text = str(damage_value)
	add_child(dmg)
```

7. Color states.

```GDScript
@export var color_high: Color
@export var color_mid: Color
@export var color_low: Color

func healthColorState():
	var ratio: float = float(self.curHealth) / self.maxHealth
	print(ratio)
	if ratio > 0.5:
		health_bar.color = color_high
	elif ratio > 0.25:
		health_bar.color = color_mid
	else:
		health_bar.color = color_low
```
