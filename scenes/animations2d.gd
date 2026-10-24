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
