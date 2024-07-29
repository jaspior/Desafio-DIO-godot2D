class_name SlashAttack
extends Node2D


@export var level := 0
@export var player : Player
@export var can_flip: bool = true

@export var base_dmg := 1
@export var damage := 10

@onready var timerAttack = $Timer
@onready var animation_player = $AnimationPlayer
@onready var hit_box = $HitBox



func _physics_process(delta) -> void:
	if can_flip:
		flip_direction()


func flip_direction() ->void:
	if player and player.sprite.flip_h:
		scale.x = -1
	else:
		scale.x = 1

func deal_damage() -> void:
	var bodies = hit_box.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			body.damage(damage*base_dmg)


func _on_timer_timeout():
	animation_player.play("attack_1")
	
