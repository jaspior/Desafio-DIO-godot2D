class_name Enemy
extends CharacterBody2D


@onready var sprite_2d = $Sprite2D


@export_category("Life")
@export var health: int = 999
@export var player : Player
@export var has_hurt_anim : bool = false
@export var damage_attack := 1

var damage_digit : PackedScene
var hurt : bool = false

func _ready():
	damage_digit = preload("res://attacks/dmg_text.tscn")


func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu dano de ", amount, ". A vida total é de ", health)

	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)

	var damage_digit = damage_digit.instantiate()
	
	damage_digit.value = amount
	
	damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	
	if has_hurt_anim:
		sprite_2d.play("hurt")
		hurt = true
		await  sprite_2d.animation_finished
		sprite_2d.play("walk")
		hurt = false
	
