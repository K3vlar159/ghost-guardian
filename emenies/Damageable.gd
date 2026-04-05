extends Node


class_name Damageable

@export var health : float = 20 :
	get:
		return health
	set(value):
		health = value

func hit(damage : int, knockback_direction):
	health -= damage
	SignalBus.emit_signal("on_hit", get_parent(), knockback_direction)

