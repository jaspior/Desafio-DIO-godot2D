class_name Enemy
extends CharacterBody2D


@export_category("Life")
@export var health: int = 999

var damage_digit : PackedScene

func _ready():
	damage_digit = preload("res://attacks/dmg_text.tscn")


func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu dano de ", amount, ". A vida total é de ", health)

	var damage_digit = damage_digit.instantiate()
	
	damage_digit.value = amount
	
	damage_digit.global_position = global_position
	
	get_parent().add_child(damage_digit)
