extends Node

@export var speed: float = 1


var player : Player 
var enemy: Enemy
var sprite: AnimatedSprite2D


func _ready():
	enemy = get_parent()
	player = get_parent().player
	sprite = enemy.get_node("Sprite2D")


func _physics_process(delta: float) -> void:
	# Ignorar GameOver
		
	# Calcular direção
	if !enemy.hurt:
		var player_position = player.global_position
		var difference = player_position - enemy.position
		var input_vector = difference.normalized()
		
		# Movimento
		enemy.velocity = input_vector * speed * 50.0
		enemy.move_and_slide()

	# Girar sprite
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true
