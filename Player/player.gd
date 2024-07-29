class_name  Player
extends CharacterBody2D

@export_category("Movement")
@export var speed := 1


@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer


var input_vector : Vector2 = Vector2.ZERO
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false


func _physics_process(delta) -> void:
	
	# ler o input
	read_input()
	
	
	
	#animações
	play_animations()
	if not is_attacking:
		rotate_sprite()
	
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.1)
	move_and_slide()


func read_input() -> void:
	# Obter o input vector
	input_vector = Input.get_vector("left", "right", "up", "down")
	
	# Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()


func play_animations() -> void:
	# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("Walk")
			else:
				animation_player.play("Idle")

func rotate_sprite() -> void:
	# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
