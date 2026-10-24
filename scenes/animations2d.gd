extends Node
class_name Animation2D

static func DeathAnimation (
	sprite: Sprite2D, 
	spawnPoint: Vector2, 
	rotationDegrees: float, 
	initialScale: Vector2,
	offset: float
	) -> Tween:
		
	# Reset Sprite
	sprite.visible = true
	sprite.position = spawnPoint
	sprite.rotation = 0
	sprite.scale = initialScale
	
	var deathTween = sprite.create_tween().set_parallel(true)
	
	# 1. Hop
	var hopDuration: float = 0.18
	deathTween.chain().tween_property(sprite, "position", spawnPoint + Vector2(offset/2, -40), hopDuration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	deathTween.tween_property(sprite, "scale", initialScale * Vector2(0.8, 1.2), hopDuration)
	deathTween.tween_property(sprite, "modulate", Color.WHITE, hopDuration)
	
	# 2. Fall
	var fallDuration: float = 0.32
	deathTween.chain().tween_property(sprite, "position", spawnPoint + Vector2(offset, 150), fallDuration) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_IN)
	deathTween.tween_property(sprite, "rotation_degrees", rotationDegrees, fallDuration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	deathTween.tween_property(sprite, "scale", Vector2.ZERO, fallDuration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	deathTween.tween_property(sprite, "modulate:a", 0.0, fallDuration) \
		.set_delay(hopDuration) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)
	
	return deathTween

static func RespawnAnimation (
	sprite: Sprite2D, 
	initialScale: Vector2
	) -> Tween:
	# Reset Sprite
	sprite.visible = true
	sprite.scale = Vector2(0,0)
	sprite.modulate.a = 0
	
	var respawnTween = sprite.create_tween().set_parallel(true)
	
	# 1. Pop in
	var popDuration: float = 0.3
	respawnTween.chain().tween_property(sprite, "scale", initialScale, popDuration) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	respawnTween.tween_property(sprite, "modulate:a", 1.0, popDuration * 0.75) \
		.set_trans(Tween.TRANS_QUINT)
	
	return respawnTween

static func ShakeNode(
	node: Node, 
	shakeTimer: float, 
	shakeAmount := 2.0, 
	shakeDuration := 0.15
	) -> void:
		var startingPosition = node.position
		var shakeStrength: float = shakeAmount * (shakeTimer / shakeDuration)
		
		node.position = startingPosition + Vector2(
			randf_range(-shakeStrength, shakeStrength),
			randf_range(-shakeStrength, shakeStrength)
		)

static func HitParticles(parent: Node, position: Vector2, duration:= 0.6) -> void :
	var particles := CPUParticles2D.new()
	# Set Up
	particles.emitting = false
	particles.amount = 16
	particles.lifetime = duration
	particles.explosiveness = 1.0
	particles.one_shot = true
	
	# Movement
	particles.direction = Vector2.UP
	particles.spread = 180.0
	particles.initial_velocity_min = 160.0
	particles.initial_velocity_max = 200.0
	particles.gravity = Vector2(0, 80)
	
	# Aesthetics
	var baseColor: Color = Color(0.95, 0.95, 0.95, 1.0)
	var fadeColor: Color = Color(0.95, 0.95, 0.95, 0.0)
	particles.scale_amount_min = 1.0
	particles.scale_amount_max = 3.0
	particles.color = baseColor
	var fade := Gradient.new()
	fade.set_color(0, baseColor)
	fade.set_color(1, fadeColor)
	particles.color_ramp = fade
	
	parent.add_child(particles)
	particles.global_position = position
	particles.emitting = true
	particles.finished.connect(particles.queue_free)

static func DeathParticles(parent: Node, position: Vector2, duration:= 0.6) -> void :
	var particles := CPUParticles2D.new()
	# Set Up
	particles.emitting = false
	particles.amount = 64
	particles.lifetime = duration
	particles.explosiveness = 1.0
	particles.one_shot = true
	
	# Movement
	particles.direction = Vector2.UP
	particles.spread = 180.0
	particles.initial_velocity_min = 160.0
	particles.initial_velocity_max = 320.0
	particles.gravity = Vector2(0, 80)
	
	# Aesthetics
	var baseColor: Color = Color(0.95, 0.95, 0.95, 1.0)
	var fadeColor: Color = Color(0.95, 0.95, 0.95, 0.0)
	particles.scale_amount_min = 5.0
	particles.scale_amount_max = 8.0
	particles.color = baseColor
	var fade := Gradient.new()
	fade.set_color(0, baseColor)
	fade.set_color(1, fadeColor)
	particles.color_ramp = fade
	
	parent.add_child(particles)
	particles.global_position = position
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
