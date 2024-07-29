class_name  Player
extends CharacterBody2D

@export_category("Movement")
@export var speed := 1
@export var health := 1000
@export var max_health := 1000


@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var hurt_box = $HurtBox
@onready var timer = $Timer


var input_vector : Vector2 = Vector2.ZERO
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var was_hurt = false


func _physics_process(delta) -> void:
	
	# ler o input
	read_input()
	
	
	
	#animações
	play_animations()
	if not is_attacking:
		rotate_sprite()
		
	# confirma dano
	if not was_hurt:
		update_hitbox_detection(delta)
	
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.1)
	move_and_slide()
	
	## se quiser dano continuo, sem timer:
	# const dmr_rate := 5.0
	# var overlaping = hurt_box.get_overlapping_bodies()
	# if overlaping.size() > 0:
	#	health -= dmr_rate * overlapings.size()*delta
		


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

func damage(amount: int) -> void:
	if health <= 0: return
	
	health -= amount
	print("Player recebeu dano de ", amount, ". A vida total é de ", health, "/", max_health)
	
	# Piscar node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)

func update_hitbox_detection(delta: float) -> void:

	var bodies = hurt_box.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			var enemy: Enemy = body
			var damage_amount = body.damage_attack
			damage(damage_amount)
			timer.start()
			was_hurt = true


func _on_timer_timeout():
	was_hurt = false
