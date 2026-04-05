extends Area2D

@export var damage : int = 1
@onready var melee_hitbox : CollisionShape2D = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	#SignalBus.connect("E1attack_direction_changed", attack_direction_changed)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player and !(body.dead) and !(get_parent().dead):
		var attack_direction_sign = sign(get_parent().attackDirection.x)
		if(attack_direction_sign > 0):
			body.hurt(damage,Vector2.RIGHT)
		elif(attack_direction_sign < 0):
			body.hurt(damage,Vector2.LEFT)
		else:
			body.hurt(damage,Vector2.ZERO)
		get_parent().attack_player()


	
#func attack_direction_changed(facing_right:bool):
	
