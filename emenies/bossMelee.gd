extends Area2D

@export var damage : int = 1
@onready var melee_hitbox : CollisionShape2D = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("E1attack_direction_changed", attack_direction_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player and !(get_parent().dead):
		var attack_direction_sign = sign(get_parent().attackDirection.x)
		if(attack_direction_sign > 0):
			body.hurt(damage,Vector2.RIGHT)
		elif(attack_direction_sign < 0):
			body.hurt(damage,Vector2.LEFT)
		else:
			body.hurt(damage,Vector2.ZERO)
		SignalBus.emit_signal("blink")


	
func attack_direction_changed(facing_right:bool):
	if(facing_right):
		melee_hitbox.position = melee_hitbox.facing_right_pos
	else:
		melee_hitbox.position = melee_hitbox.facing_left_pos
