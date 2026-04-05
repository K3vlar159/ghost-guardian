extends Area2D

@export var damage : int = 8
@onready var melee_hitbox : CollisionShape2D = $MeleeHitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("attack_direction_changed", attack_direction_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			
			var attack_direction_sign = sign(get_parent().attackDirection.x)
			
			if(attack_direction_sign > 0):
				child.hit(damage,Vector2.RIGHT)
			elif(attack_direction_sign < 0):
				child.hit(damage,Vector2.LEFT)
			else:
				child.hit(damage,Vector2.ZERO)
	
func attack_direction_changed(facing_right:bool):
	if(facing_right):
		melee_hitbox.position = melee_hitbox.facing_right_pos
	else:
		melee_hitbox.position = melee_hitbox.facing_left_pos
