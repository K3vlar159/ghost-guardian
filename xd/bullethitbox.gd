extends CollisionShape2D

@export var damage : int = 8



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("xdd")
	for child in body.get_children():
		if child is Damageable:
			var attack_direction_sign = sign(get_parent().direction.x)
			if(attack_direction_sign > 0):
				child.hit(damage,Vector2.RIGHT)
			elif(attack_direction_sign < 0):
				child.hit(damage,Vector2.LEFT)
			else:
				child.hit(damage,Vector2.ZERO)

